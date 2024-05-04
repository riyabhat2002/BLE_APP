#include "soil.h"

cy_rslt_t soil_result;
cyhal_adc_t adc_obj;
int32_t adc_result;
float moisture_level;

float read_soil_moisture(){
    soil_result = cyhal_adc_init(&adc_obj, P10_5, NULL);
    if (soil_result != CY_RSLT_SUCCESS) {
        CY_ASSERT(0);  // Handle error or halt
    }
    
    cyhal_adc_channel_t adc_channel;
    if (soil_result != CY_RSLT_SUCCESS) {
        CY_ASSERT(0);  // Handle error or halt
    }

    /* Initialize ADC channel, allocate channel number 0 to pin 10[0] as this is the first channel initialized */
    const cyhal_adc_channel_config_t channel_config = { .enable_averaging = false, .min_acquisition_ns = 220, .enabled = true };
    soil_result = cyhal_adc_channel_init_diff(&adc_channel, &adc_obj, P10_5, CYHAL_ADC_VNEG, &channel_config);
    if(soil_result != CY_RSLT_SUCCESS){
        CY_ASSERT(0);
    }
    
    adc_result = cyhal_adc_read(&adc_channel);
    if (adc_result < 0 || adc_result > 4095) {
        // printf("ADC read error or out of range value: %ld\r\n", adc_result);
    }

    // Assuming a reference voltage of 3.3V and a 12-bit ADC resolution
    float voltage = (3.3 * adc_result) / 4095.0;
    const int ADC_dry = 800;  // ADC value for dry soil
    const int ADC_wet = 300;  // ADC value for wet soil

    moisture_level = (float)(adc_result - ADC_dry) / (ADC_dry - ADC_wet) * 100;
    cyhal_system_delay_ms(500); // Delay between readings

    // Cleanup ADC
    cyhal_adc_channel_free(&adc_channel);
    cyhal_adc_free(&adc_obj);
    return moisture_level;
}
