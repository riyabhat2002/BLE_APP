#ifndef __FAN_CONTROL_H__
#define __FAN_CONTROL_H__

#include "cy_pdl.h"
#include "cyhal.h"
#include "cybsp.h"

#undef CONN_CONTROL_J300
#undef CONN_CONTROL_J301
#define  CONN_CONTROL_J302

#if defined(CONN_CONTROL_J300)
#define PIN_FAN_1       		P9_1 /* ADD CODE */
#define PIN_FAN_2   		    P9_3 /* ADD CODE */
#define PIN_FAN_3    			P10_5 /* ADD CODE */
#elif defined(CONN_CONTROL_J301)
#define PIN_FAN_1       		P10_1 /* ADD CODE */
#define PIN_FAN_2   		    P10_3 /* ADD CODE */
#define PIN_FAN_3    			P10_4 /* ADD CODE */
#elif defined(CONN_CONTROL_J302)
#define PIN_FAN_1       		P5_1 /* ADD CODE */
#define PIN_FAN_2   		    P5_3 /* ADD CODE */
#define PIN_FAN_3    			P10_6 /* ADD CODE */
#else
#error "MUST DEFINE FAN CONNECTOR"
#endif

// Pin definitions for the ECE453 Staff Dev board

cy_rslt_t switch_control_init(void);

void turn_switch1_on(void);
void turn_switch1_off(void);

void turn_switch2_on(void);
void turn_switch2_off(void);

void turn_switch3_on(void);
void turn_switch3_off(void);

#endif // __FAN__CONTROL_H__