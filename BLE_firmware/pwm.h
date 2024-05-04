#ifndef PWM_H_
#define PWM_H_

#include "cy_pdl.h"
#include "cyhal.h"
#include "cybsp.h"
#include "cyhal_pwm.h"

cy_rslt_t pwm_init(void);
cy_rslt_t pwm_start(void);
cy_rslt_t pwm_stop(void);

#endif // PWM_H_