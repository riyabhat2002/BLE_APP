#include "pwm.h"


cy_rslt_t result;

uint32_t pwm_frequency = 5000; // Initial frequency: 5000 Hz
cy_rslt_t rslt1;
cy_rslt_t rslt2;
cyhal_pwm_t pwm_obj;
cyhal_pwm_t pwm_obj1;


cy_rslt_t pwm_init(void) {


    rslt1 = cyhal_pwm_init(&pwm_obj, P5_2, NULL);
    if (rslt1 != CY_RSLT_SUCCESS)
    {
        CY_ASSERT(0);
		printf("pwm 1\r\n");
    }
    rslt2 = cyhal_pwm_init(&pwm_obj1, P5_0, NULL);
    if (rslt2 != CY_RSLT_SUCCESS)
    {
		printf("pwm 2\r\n");
        CY_ASSERT(0);
    }
	rslt1 = cyhal_pwm_set_duty_cycle(&pwm_obj, 1, pwm_frequency);
	if (rslt1 != CY_RSLT_SUCCESS)
	{
		CY_ASSERT(0);
	}
	rslt2 = cyhal_pwm_set_duty_cycle(&pwm_obj1, 100, pwm_frequency);
	if (rslt2 != CY_RSLT_SUCCESS)
	{
		printf("pwm 3\r\n");
		CY_ASSERT(0);

        return CY_RSLT_SUCCESS;
	}



}

cy_rslt_t pwm_start(void) {
    /* Start the PWM output */
	rslt1 = cyhal_pwm_start(&pwm_obj);
	if (rslt1 != CY_RSLT_SUCCESS)
	{
		CY_ASSERT(0);
	}

	rslt2 = cyhal_pwm_start(&pwm_obj1);
	if (rslt2 != CY_RSLT_SUCCESS)
	{
		CY_ASSERT(0);
	}

    return CY_RSLT_SUCCESS;
}

cy_rslt_t pwm_stop(void) {
    /* Stop the PWM output */
	rslt1 = cyhal_pwm_stop(&pwm_obj);
	if (rslt1 != CY_RSLT_SUCCESS)
	{
		CY_ASSERT(0);
	}

	rslt2 = cyhal_pwm_stop(&pwm_obj1);
	if (rslt2 != CY_RSLT_SUCCESS)
	{
		CY_ASSERT(0);
	}

    return CY_RSLT_SUCCESS;
}