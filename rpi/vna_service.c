#include "vna_service.h"

#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <time.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>
#include <assert.h>
#include <unistd.h>
#include <errno.h>

#include "lib/bluetooth.h"
#include "lib/hci.h"
#include "lib/hci_lib.h"
#include "lib/l2cap.h"
#include "lib/uuid.h"

#include "src/shared/mainloop.h"
#include "src/shared/util.h"
#include "src/shared/att.h"
#include "src/shared/queue.h"
#include "src/shared/timeout.h"
#include "src/shared/gatt-db.h"
#include "src/shared/gatt-server.h"

#include "vna_bluetooth_info.h"

#define UUID_VNA_SERVICE	"e9d25159-99bb-4c07-8094-8262f45ae3b6"
#define UUID_VNA_CMD	    "3033d8d7-9f64-4c89-87d0-0a584bc48da0"
#define UUID_VNA_DATA		"fe4d098a-e8c3-4504-8d47-b07089b5e6e0"

static void vna_cmd_read_cb(struct gatt_db_attribute *attrib,
                            unsigned int id, uint16_t offset,
                            uint8_t opcode, struct bt_att *att,
                            void *user_data)
{
	VNAService *vna = user_data;
	uint8_t error = 0;
	size_t len = 0;
	const char *value = NULL;

	len = vna->cmd_len;

	if (offset > len) {
		error = BT_ATT_ERROR_INVALID_OFFSET;
		goto done;
	}

	len -= offset;
	value = len ? &vna->cmd[offset] : NULL;

done:
	gatt_db_attribute_read_result(attrib, id, error, (uint8_t*)value, len);
}

static void vna_cmd_write_cb(struct gatt_db_attribute *attrib,
					unsigned int id, uint16_t offset,
					const uint8_t *value, size_t len,
					uint8_t opcode, struct bt_att *att,
					void *user_data)
{
	VNAService *vna = user_data;
	uint8_t error = 0;

	/* If the value is being completely truncated, clean up and return */
	if (!(offset + len)) {
		free(vna->cmd);
		vna->cmd = NULL;
		vna->cmd_len = 0;
		goto done;
	}

	/* Implement this as a variable length attribute value. */
	if (offset > vna->cmd_len) {
		error = BT_ATT_ERROR_INVALID_OFFSET;
		goto done;
	}

	if (offset + len != vna->cmd_len) {
		char *temp_cmd;

		temp_cmd = realloc(vna->cmd, offset + len + 1);
		if (!temp_cmd) {
			error = BT_ATT_ERROR_INSUFFICIENT_RESOURCES;
			goto done;
		}

		vna->cmd = temp_cmd;
		vna->cmd_len = offset + len;
        temp_cmd[offset + len] = '\0';
	}

	if (value)
    {
		memcpy(vna->cmd + offset, value, len);
        send_cmd_vna_device(vna->vna_dev, vna->cmd);

        char* buf;
        size_t count;

        read_data_vna_device(vna->vna_dev, &buf, &count);

        if(count)
        {
            if(count > BT_RPI_MAX_BYTE_PER_NOTIF)
            {
                printf("WARNINGS: vna data too big for notif\n");
            }
            bt_gatt_server_send_notification(vna->gatt,
                                vna->cmd_data_handle,
                                (uint8_t*)buf, count);
            free(buf);
        }
    }

done:
	gatt_db_attribute_write_result(attrib, id, error);
}

static void vna_cmd_ext_prop_read_cb(struct gatt_db_attribute *attrib,
					unsigned int id, uint16_t offset,
					uint8_t opcode, struct bt_att *att,
					void *user_data)
{
	uint8_t value[2];

	value[0] = BT_GATT_CHRC_EXT_PROP_RELIABLE_WRITE;
	value[1] = 0;

	gatt_db_attribute_read_result(attrib, id, 0, value, sizeof(value));
}

static bool vna_data_cb(void *user_data)
{
    (void)(user_data);
	// VNAService *vna = user_data;
    // char* buf;
    // size_t count;

    // read_data_vna_device(vna->vna_dev, &buf, &count);

    // if(count)
    // {
    //     if(count > BT_RPI_MAX_BYTE_PER_NOTIF)
    //     {
    //         printf("WARNINGS: vna data too big for notif\n");
    //     }
    //     bt_gatt_server_send_notification(vna->gatt,
    //                         vna->cmd_data_handle,
    //                         (uint8_t*)buf, count);
    //     free(buf);
    // }

	return true;
}

static void update_vna_data(VNAService *vna)
{
    if (!vna->cmd_data_enabled) {
		timeout_remove(vna->cmd_timeout_id);
		return;
	}
	vna->cmd_timeout_id = timeout_add(1000, vna_data_cb, vna, NULL);
}

static void cmd_data_ccc_read_cb(struct gatt_db_attribute *attrib,
					unsigned int id, uint16_t offset,
					uint8_t opcode, struct bt_att *att,
					void *user_data)
{
	VNAService *vna = user_data;
	uint8_t value[2];

	value[0] = vna->cmd_data_enabled ? 0x01 : 0x00;
	value[1] = 0x00;

	gatt_db_attribute_read_result(attrib, id, 0, value, 2);
}

static void cmd_data_ccc_write_cb(struct gatt_db_attribute *attrib,
					unsigned int id, uint16_t offset,
					const uint8_t *value, size_t len,
					uint8_t opcode, struct bt_att *att,
					void *user_data)
{
	VNAService* vna = user_data;
	uint8_t ecode = 0;

	if (!value || len != 2) {
		ecode = BT_ATT_ERROR_INVALID_ATTRIBUTE_VALUE_LEN;
		goto done;
	}

	if (offset) {
		ecode = BT_ATT_ERROR_INVALID_OFFSET;
		goto done;
	}

	if (value[0] == 0x00)
		vna->cmd_data_enabled = false;
	else if (value[0] == 0x01) {
		if (vna->cmd_data_enabled) {
			goto done;
		}

		vna->cmd_data_enabled = true;
	} else
		ecode = 0x80;

	update_vna_data(vna);

done:
	gatt_db_attribute_write_result(attrib, id, ecode);
}

void init_vna_service(VNAService *vna, struct bt_gatt_server* gatt, VNADevice* vna_dev)
{
    vna->gatt = gatt;

    vna->cmd = NULL;
    vna->cmd_len = 0;
    vna->cmd_data_enabled = false;

    vna->vna_dev = vna_dev;
}

void destroy_vna_service(VNAService *vna)
{
    timeout_remove(vna->cmd_timeout_id);
    free(vna->cmd);
}

void populate_vna_service(VNAService *vna, struct gatt_db *db)
{
	bt_uuid_t uuid;
	struct gatt_db_attribute *service, *vna_data;

	bt_string_to_uuid(&uuid, UUID_VNA_SERVICE);
	service = gatt_db_add_service(db, &uuid, true, 8);
	vna->service_handle = gatt_db_attribute_get_handle(service);

	bt_string_to_uuid(&uuid, UUID_VNA_CMD);
	gatt_db_service_add_characteristic(service, &uuid,
					BT_ATT_PERM_READ | BT_ATT_PERM_WRITE,
					BT_GATT_CHRC_PROP_READ | BT_GATT_CHRC_PROP_WRITE | BT_GATT_CHRC_PROP_EXT_PROP,
					vna_cmd_read_cb,
					vna_cmd_write_cb,
					vna);

	bt_uuid16_create(&uuid, GATT_CHARAC_EXT_PROPER_UUID);
	gatt_db_service_add_descriptor(service, &uuid, BT_ATT_PERM_READ,
					vna_cmd_ext_prop_read_cb,
					NULL, vna);
    
    bt_string_to_uuid(&uuid, UUID_VNA_DATA);
	vna_data = gatt_db_service_add_characteristic(service, &uuid,
						BT_ATT_PERM_NONE,
						BT_GATT_CHRC_PROP_NOTIFY,
						NULL, NULL, NULL);
	vna->cmd_data_handle = gatt_db_attribute_get_handle(vna_data);

	bt_uuid16_create(&uuid, GATT_CLIENT_CHARAC_CFG_UUID);
	gatt_db_service_add_descriptor(service, &uuid,
					BT_ATT_PERM_READ | BT_ATT_PERM_WRITE,
					cmd_data_ccc_read_cb,
					cmd_data_ccc_write_cb, vna);

	gatt_db_service_set_active(service, true);
}