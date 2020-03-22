/**
 * @file vna_service.h
 * @brief custom BLE service for the vna
 * 
 * @copyright Copyright (c) 2020
 * 
 */

#ifndef _VNA_SERVICE_H
#define _VNA_SERVICE_H
#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

#include "vna_device.hpp"

// forward declaration since bluez include files is a mess
struct gatt_db;
struct bt_gatt_server;

typedef struct {
    struct bt_gatt_server* gatt;

    char *cmd;
	size_t cmd_len;
    unsigned int cmd_timeout_id;
    uint16_t cmd_data_handle;
    bool cmd_data_enabled;

    uint16_t service_handle;

    VNADevice* vna_dev;
} VNAService;

void init_vna_service(VNAService *vna, struct bt_gatt_server* gatt, VNADevice* vna_dev);
void destroy_vna_service(VNAService *vna);
void populate_vna_service(VNAService *vna, struct gatt_db *db);

#ifdef __cplusplus
}
#endif
#endif // !_VNA_SERVICE_H