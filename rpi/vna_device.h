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

/**
 * @brief send string cmd to vna
 * 
 * @param cmd the cmd to send, doesn't need \r at the end
 * @return true no error
 * @return false something went wrong
 */
bool send_cmd_vna_device(VNADevice* vna, const char* cmd);
/**
 * @brief read data from vna until there is nothing left to read
 * 
 * @param buf output data, will already be trimmed to not have shell prompt, will be NULL if there 
 * is no data. YOU NEED TO FREE THIS BUFFER YOURSELF
 * @param count byte count of output buffer, 0 if no data
 */
void read_data_vna_device(VNADevice* vna, char **buf, size_t* count);

#endif // ! _VNA_DEVICE_H