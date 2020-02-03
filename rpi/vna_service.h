/**
 * @file vna_service.h
 * @brief custom BLE service for the vna
 * 
 * @copyright Copyright (c) 2020
 * 
 */

#ifndef _VNA_SERVICE_H
#define _VNA_SERVICE_H

#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>

// forward declaration since bluez include files is a mess
struct gatt_db;
struct bt_gatt_server;

typedef struct {
    struct bt_gatt_server* gatt;

    uint8_t *cmd;
	size_t cmd_len;
    unsigned int cmd_timeout_id;
    uint16_t cmd_data_handle;
    bool cmd_data_enabled;

    uint16_t service_handle;
} VNAService;

void init_vna_service(VNAService *vna, struct bt_gatt_server* gatt);
void destroy_vna_service(VNAService *vna);
void populate_vna_service(VNAService *vna, struct gatt_db *db);

#endif // !_VNA_SERVICE_H