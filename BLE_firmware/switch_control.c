    #include "switch_control.h"

cy_rslt_t switch_control_init(void)
{
	cy_rslt_t rslt; 
	rslt = cyhal_gpio_init(PIN_FAN_1, CYHAL_GPIO_DIR_OUTPUT,CYHAL_GPIO_DRIVE_STRONG, false);
    if(rslt != CY_RSLT_SUCCESS)
    {
        printf("Error initializing 1st Fan IO drive\n\r");
        while(1){};
    }

    Cy_SysLib_Delay(50);
    
    rslt = cyhal_gpio_init(PIN_FAN_2, CYHAL_GPIO_DIR_OUTPUT,CYHAL_GPIO_DRIVE_STRONG, false);
    if(rslt != CY_RSLT_SUCCESS)
    {
        printf("Error initializing 2nd Fan IO drive\n\r");
        return rslt;
    }

    rslt = cyhal_gpio_init(PIN_FAN_3, CYHAL_GPIO_DIR_OUTPUT,CYHAL_GPIO_DRIVE_STRONG, false);
    if(rslt != CY_RSLT_SUCCESS)
    {
        printf("Error initializing 3rd Fan IO drive\n\r");
        return rslt;
    }
    return rslt;
}

void turn_switch1_on(void) {
	cyhal_gpio_write(PIN_FAN_1, 1);
}

void turn_switch1_off(void) {
	cyhal_gpio_write(PIN_FAN_1, 0);
}

void turn_switch2_on(void) {
	cyhal_gpio_write(PIN_FAN_2, 1);
}

void turn_switch2_off(void) {
	cyhal_gpio_write(PIN_FAN_2, 0);
}

void turn_switch3_on(void) {
	cyhal_gpio_write(PIN_FAN_3, 1);
}

void turn_switch3_off(void) {
	cyhal_gpio_write(PIN_FAN_3, 0);
}