#include "vna_device.h"

#include <string.h>

#define VNA_VID 0x0483
#define VNA_PID 0x5740

bool init_vna_device(VNADevice* vna)
{
    struct sp_port **port_list;

	vna->port = NULL;

	if (sp_list_ports(&port_list) != SP_OK) {
		printf("sp_list_ports() failed!\n");
		return false;
	}

	for (int i = 0; port_list[i] != NULL; i++) {
		struct sp_port *port = port_list[i];
        int vid, pid;

		/* Get the name of the port. */
		if(SP_OK == sp_get_port_usb_vid_pid(port, &vid, &pid))
        {
            if((VNA_VID == vid) && (VNA_PID == pid))
            {
                printf("found vna\n");
                sp_copy_port(port, &(vna->port));
            }
        }
	}

	sp_free_port_list(port_list);

    if(NULL == vna->port)
    {
        printf("can't find vna\n");
        return false;
    }

    sp_set_bits(vna->port, 8);
    sp_set_stopbits(vna->port, 1);
    sp_set_parity(vna->port, SP_PARITY_NONE);
    sp_set_baudrate(vna->port, 9600);
    if(SP_OK != sp_open(vna->port, SP_MODE_READ_WRITE))
    {
        printf("can't open vna port\n");
        return false;
    }

    return true;
}

void destroy_vna_device(VNADevice* vna)
{
    sp_close(vna->port);
    sp_free_port(vna->port);
}

bool send_cmd_vna_device(VNADevice* vna, const char* cmd)
{
    const size_t temp_cmd_size = strlen(cmd) + 2;
    char* temp_cmd = (char*)malloc(temp_cmd_size);
    snprintf(temp_cmd, temp_cmd_size - 1,"%s\r", cmd);
    if(sp_blocking_write(vna->port, temp_cmd, temp_cmd_size, 0) < 0)
    {
        printf("error writing to vna\n");
        return false;
    }
    sp_drain(vna->port);
    return true;
}

// TODO(khoi): Discuss data transmission format
// bool read_data_vna_device(VNADevice* vna, void *buf, size_t count)
// {
//     sp_blocking_read
// }