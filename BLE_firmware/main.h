/*
 * main.h
 *
 *  Created on: Aug 30, 2022
 *      Author: Joe Krachey
 */

#ifndef MAIN_H_
#define MAIN_H_
#include "cy_pdl.h"
#include "cy_retarget_io.h"
#include "cybsp.h"
#include "cyhal.h"
#include "ble_findme.h"
#include "bme280.h"
#include "usr_btn.h"
#include "bme280.h"
#include "relay.h"
#include "i2c.h"
#include "soil.h"
#include "pwm.h"

// bme280_dev dev;


#define ECE453_USR_BTN P5_6
#define ECE453_USR_LED P5_5

#define ECE453_DEBUG_TX	P6_5
#define ECE453_DEBUG_RX P6_4



#endif /* MAIN_H_ */
