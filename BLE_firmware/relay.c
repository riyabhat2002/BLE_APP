/**
 * @file relay.c
 * @author Joe Krachey (jkrachey@wisc.edu)
 * @brief 
 * @version 0.1
 * @date 2024-02-06
 * 
 * @copyright Copyright (c) 2024
 * 
 */
#include "relay.h"

cy_rslt_t relay_init(void)
{
	cy_rslt_t rslt; 
	/* ADD CODE to initialize the IO pins that turn the relays on/off */
	rslt = cyhal_gpio_init(PIN_RELAY_2, CYHAL_GPIO_DIR_OUTPUT,CYHAL_GPIO_DRIVE_STRONG, false);
    if(rslt != CY_RSLT_SUCCESS)
    {
        printf("Error initializing 1st Relay\n\r");
        return rslt;
    }

    /* Initialize LED */
    rslt = cyhal_gpio_init(PIN_RELAY_3, CYHAL_GPIO_DIR_OUTPUT,CYHAL_GPIO_DRIVE_STRONG, false);
    if(rslt != CY_RSLT_SUCCESS)
    {
        printf("Error initializing 2nd Relay\n\r");
        return rslt;
    }
    return rslt;
}

void switch_relay1_on(void) {
	cyhal_gpio_write(PIN_RELAY_2, 1);
}

void switch_relay1_off(void) {
	cyhal_gpio_write(PIN_RELAY_2, 0);
}

void switch_relay2_on(void) {
	cyhal_gpio_write(PIN_RELAY_3, 1);
}

void switch_relay2_off(void) {
	cyhal_gpio_write(PIN_RELAY_3, 0);
}
