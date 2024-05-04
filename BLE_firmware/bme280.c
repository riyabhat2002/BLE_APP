#include "bme280.h"
#include "i2c.h"
#include <stdio.h>
#include <stdint.h>


cy_rslt_t bme_driver_write_reg(uint8_t reg, uint8_t val) {
    uint8_t data[2] = {reg, val};
    cy_rslt_t result;
    
    // Perform the I2C write operation
    result = cyhal_i2c_master_write(&i2c_master_obj, BME280_I2C_ADDR_PRIM, data, 2, 0, true);
    return result;
}

cy_rslt_t bme_driver_read_reg(uint8_t reg, uint8_t *buffer, size_t length) {
    cy_rslt_t result;

    // Write the register address to the sensor. This step is necessary to set the sensor's internal address pointer
    result = cyhal_i2c_master_write(&i2c_master_obj, BME280_I2C_ADDR_PRIM, &reg, 1, 0, false);
    if (result != CY_RSLT_SUCCESS) {
        return result;  // Return the error if the write operation fails
    }

    // Read data from the sensor into the buffer
    result = cyhal_i2c_master_read(&i2c_master_obj, BME280_I2C_ADDR_PRIM, buffer, length, 0, true);
    return result;  // Return the result of the read operation
}

cy_rslt_t bme_read_calibration_data(bme280_dev *dev) {
    cy_rslt_t result;
    uint8_t calib_data[BME280_LEN_TEMP_PRESS_CALIB_DATA];
    if (dev == NULL) {
        // printf("Failed to allocate memory for BME280 device.\n");
        return CY_RSLT_TYPE_ERROR; // Return appropriate error code
    }

    // Read calibration data from the sensor registers
    result = bme_driver_read_reg(BME280_REG_TEMP_PRESS_CALIB_DATA, calib_data, BME280_LEN_TEMP_PRESS_CALIB_DATA);
    if (result != CY_RSLT_SUCCESS) {
        // printf("Failed to read calibration data from sensor.\n");
        return result;
    }

    // Parse calibration data and populate the temp_dev structure
    dev->calib_data.dig_t1 = (uint16_t)((calib_data[1] << 8) | calib_data[0]);
    dev->calib_data.dig_t2 = (int16_t)((calib_data[3] << 8) | calib_data[2]);
    dev->calib_data.dig_t3 = (int16_t)((calib_data[5] << 8) | calib_data[4]);
    
    dev->calib_data.dig_h1 = calib_data[15];

    result = bme_driver_read_reg(BME280_REG_HUMIDITY_CALIB_DATA, calib_data, BME280_LEN_HUMIDITY_CALIB_DATA);

    dev->calib_data.dig_h2 = (int16_t)((calib_data[1] << 8) | calib_data[0]);
    // printf("h1 %ld\r\n", temp_dev->calib_data.dig_h1);
    dev->calib_data.dig_h3 = calib_data[2];
    dev->calib_data.dig_h4 = (int16_t)((calib_data[3] << 4) | (calib_data[4] & 0x0F));
    dev->calib_data.dig_h5 = (int16_t)((((calib_data[4] >> 4) & 0x0F)<< 8) | calib_data[5]);
    dev->calib_data.dig_h6 = (int8_t)(calib_data[6]);

    if (result != CY_RSLT_SUCCESS) {
        printf("Failed to read calibration data from sensor.\n");
        return result;
    }
    // Parse other calibration coefficients in a similar way
    if (dev->calib_data.dig_t1 == 0 || dev->calib_data.dig_t2 == 0) {
        printf("Calibration data not initialized correctly.\n");
        return CY_RSLT_TYPE_ERROR;
    }
    // Assign the allocated memory address to the pointer passed as argument

    return CY_RSLT_SUCCESS;
}

cy_rslt_t bme280_init(bme280_dev *dev) {
    cy_rslt_t result;
    uint8_t id;

    result = bme_driver_read_reg(BME280_REG_CHIP_ID, &id, 1);
    if (result == CY_RSLT_SUCCESS && id == BME280_CHIP_ID) {
        dev->chip_id = id;
        // printf("BME280 Chip ID: 0x%x\n", id);
    } 
    else {
        // printf("Failed to read chip ID.\n");
        return BME280_E_COMM_FAIL;
    }
    // Read calibration data
    result = bme_read_calibration_data(dev);
    if (result != CY_RSLT_SUCCESS) {
        printf("Failed to read calibration data.\n");
        CY_ASSERT(0);
    }

    // Initialize other settings and configurations
    uint8_t ctrl_meas_val = 0; // Initialize the control register value
    uint8_t ctrl_hum_val = 0;  // Initialize the humidity control register value

    // Set the oversampling settings for temperature, pressure, and humidity
    ctrl_meas_val |= (BME280_OVERSAMPLING_1X << 5) | (BME280_OVERSAMPLING_1X << 2) | BME280_OVERSAMPLING_1X | BME280_POWERMODE_NORMAL;
    ctrl_hum_val |= BME280_OVERSAMPLING_1X;

    // Write the humidity control register first
    bme_driver_write_reg(BME280_REG_CTRL_HUM, ctrl_hum_val);

    // The write to the control register must follow the humidity setting
    bme_driver_write_reg(BME280_REG_CTRL_MEAS, ctrl_meas_val);

    // Set the standby time and filter settings
    uint8_t config_val = (BME280_STANDBY_TIME_1000_MS << 5) | (BME280_FILTER_COEFF_OFF << 2);
    bme_driver_write_reg(BME280_REG_CONFIG, config_val);

    return CY_RSLT_SUCCESS;
}

int32_t bme280_compensate_temperature(bme280_dev *dev, const int32_t adc_T) {
    int32_t var1, var2, temperature;

    if (dev == NULL) {
        // Handle error: invalid pointer
        return -1; // or any error code of your choice
    }
    // cy_rslt_t result = bme_read_calibration_data(dev);
    // if(result != CY_RSLT_SUCCESS){
    //     printf("calibration failed!\r\n");
    //     CY_ASSERT(0);
    // }    

    var1 = (((( adc_T >> 3 ) - ( (int32_t) dev->calib_data.dig_t1 << 1 ))) * ( (int32_t) dev->calib_data.dig_t2 )) >> 11;
    // printf("%d\n\r", var1);
    var2 = ((((( adc_T >> 4 ) - ((int32_t) dev->calib_data.dig_t1 )) * (( adc_T >> 4 ) - ( (int32_t) dev->calib_data.dig_t1 ))) >> 12) * ( (int32_t) dev->calib_data.dig_t3 )) >> 14;
    dev->calib_data.t_fine = var1 + var2;
    
    temperature = (dev->calib_data.t_fine * 5 + 128 ) >> 8;
    return temperature;
}

uint32_t bme280_compensate_pressure(bme280_dev *dev, const int32_t adc_P) {
    int64_t var1, var2, p;

    //cy_rslt_t result = bme_read_calibration_data(dev);
    // if(result != CY_RSLT_SUCCESS){
    //     printf("calibration failed!\r\n");
    //     CY_ASSERT(0);
    // }

    var1 = ( (int64_t) dev->calib_data.t_fine ) - 128000;
    var2 = var1 * var1 * (int64_t)dev->calib_data.dig_p6;
    var2 = var2 + ( ( var1 * (int64_t)dev->calib_data.dig_p5 ) << 17 );
    var2 = var2 + ( (int64_t) dev->calib_data.dig_p4 << 35 );
    var1 = ( ( var1 * var1 * (int64_t) dev->calib_data.dig_p3 ) >> 8 ) + ( ( var1 * (int64_t) dev->calib_data.dig_p2 ) << 12 );
    var1 = ( ( ( (int64_t) 1 ) << 47 ) + var1 ) * ( (int64_t) dev->calib_data.dig_p1 ) >> 33;

    if ( var1 == 0 ) {
        return 0; // Avoid exception caused by division by zero
    }

    p = 1048576 - adc_P;
    p = ( ( p << 31 ) - var2 ) * 3125;
    if ( p < 0x80000000 ) {
        p = ( p << 1 ) / (int64_t) var1;
    } else {
        p = ( p / (int64_t) var1 ) * 2;
    }
    var1 = ( (int64_t) dev->calib_data.dig_p9 * ( ( p >> 13 ) * ( p >> 13 ) ) ) >> 25;
    var2 = ( (int64_t) p * dev->calib_data.dig_p8 ) >> 19;
    p = ( ( p + var1 + var2 ) >> 8 ) + ( ( (int64_t) dev->calib_data.dig_p7 ) << 4 );

    return ( uint32_t ) p;
}

uint32_t bme280_compensate_humidity(bme280_dev *dev, const int32_t adc_H) {
   // struct bme280_calib_data *calib_data; // Pointer to calibration data
    int32_t var_H;
    uint32_t humidity;

    //cy_rslt_t result = bme_read_calibration_data(dev);
    // if(result != CY_RSLT_SUCCESS){
    //     printf("calibration failed!\r\n");
    //     CY_ASSERT(0);
    // }
    //calib_data = &(dev->calib_data); // Get pointer to calibration data
    // printf("Humidity ADC: %u\n\r", adc_H);
    if (dev == NULL) {
        printf("dev is NULL\n");
    } else {
        // printf("%u\n", dev->calib_data.t_fine);
    }
    
    // printf("%u\r\n", dev->calib_data.t_fine);
    
    var_H = (dev->calib_data.t_fine - ((int32_t)76800));
    // printf("Humidity before formula: %u\r\n", var_H);
    var_H = (((((adc_H << 14) - (((int32_t) dev->calib_data.dig_h4) << 20)
         - (((int32_t) dev->calib_data.dig_h5) * var_H)) + ((int32_t) 16384)) >> 15) * 
         (((((((var_H * ((int32_t)dev->calib_data.dig_h6)) >> 10) * (((var_H * ((int32_t)dev->calib_data.dig_h3)) >> 11) + 
         ((int32_t)32768))) >> 10) + ((int32_t)2097152)) * ((int32_t)dev->calib_data.dig_h2) + 8192) >> 14));
    // printf("Humidity AFTER 1ST STEP formula: %u\r\n", var_H);
    var_H = (var_H - (((((var_H >> 15) * (var_H >> 15)) >> 7) * ((int32_t)dev->calib_data.dig_h1)) >> 4));
    // printf("Humidity AFTER 2nd STEP formula: %u\r\n", var_H);
    var_H = (var_H < 0 ? 0 : var_H);
    // printf("Humidity AFTER 3rd STEP formula: %u\r\n", var_H);
    var_H = (var_H > 419430400 ? 419430400 : var_H);
    // printf("Humidity AFTER 4th STEP formula: %u\r\n", var_H);
    humidity = (uint32_t)(var_H>>12);
    // printf("%ld\r\n", humidity);
    
    return humidity;
}

cy_rslt_t bme280_configure() 
{
    cy_rslt_t result;

    // Set oversampling modes for temperature, pressure, and humidity
    uint8_t ctrl_meas_val = (BME280_OVERSAMPLING_1X << BME280_CTRL_TEMP_POS) |
                            (BME280_OVERSAMPLING_1X << BME280_CTRL_PRESS_POS) |
                            (BME280_OVERSAMPLING_1X << BME280_CTRL_HUM_POS);
    result = bme_driver_write_reg(BME280_REG_CTRL_MEAS, ctrl_meas_val);
    if (result != CY_RSLT_SUCCESS) {
        // printf("Failed to set oversampling modes.\n");
        return result;
    }

    // Set standby time
    uint8_t config_val = (BME280_STANDBY_TIME_1000_MS << BME280_STANDBY_POS);
    result = bme_driver_write_reg(BME280_REG_CONFIG, config_val);
    if (result != CY_RSLT_SUCCESS) {
        // printf("Failed to set standby time.\n");
        return result;
    }

    // Set filter coefficient
    uint8_t config2_val = (BME280_FILTER_COEFF_OFF << BME280_FILTER_POS);
    result = bme_driver_write_reg(BME280_REG_CONFIG, config2_val);
    if (result != CY_RSLT_SUCCESS) {
        // printf("Failed to set filter coefficient.\n");
        return result;
    }

    return CY_RSLT_SUCCESS;
}

// Function to read and print sensor data
SensorData read_sensor_data(bme280_dev *dev) {
    cy_rslt_t result;
    SensorData sensor;
    uint8_t data[BME280_LEN_P_T_H_DATA] = {0};

    // Read all sensor data from the sensor
    result = bme_driver_read_reg(BME280_REG_DATA, data, BME280_LEN_P_T_H_DATA);
    if (result != CY_RSLT_SUCCESS) {
        // printf("Failed to read sensor data.\n");
        return;
    }

    // Extract temperature from the data buffer
    int32_t adc_t = ((int32_t)data[3] << 12) | ((int32_t)data[4] << 4) | ((int32_t)data[5] >> 4);
    sensor.temperature = bme280_compensate_temperature(dev, adc_t);

    int32_t adc_p = ((int32_t)data[0] << 12) | ((int32_t)data[1] << 4) | ((int32_t)data[2] >> 4);
    sensor.pressure = bme280_compensate_pressure(dev, adc_p);

    int32_t adc_h = ((int32_t)data[6] << 8) | (int32_t)data[7];
    sensor.humidity = bme280_compensate_humidity(dev, adc_h);
    sensor.humidity = sensor.humidity >> 10;
    // printf("Humidity: %lu%%\n\r", humidity);

    // printf("Temperature: %ld.%02lu °C\n\r", temperature / 100, temperature % 100);
    // printf("Humidity: %ld%%\n\r", humidity);
    return sensor;
}