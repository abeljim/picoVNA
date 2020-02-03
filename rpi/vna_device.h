/**
 * @file vna_device.h
 * @author Khoi Trinh
 * @brief Represent a vna usb device, used for sending/receiving data through com port
 * 
 */
#ifndef _VNA_DEVICE_H
#define _VNA_DEVICE_H

#include <libserialport.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct {
	struct sp_port *port;
} VNADevice;

bool init_vna_device(VNADevice* vna);
void destroy_vna_device(VNADevice* vna);
bool send_cmd_vna_device(VNADevice* vna, const char* cmd);

#endif // ! _VNA_DEVICE_H