#include "vna_device.hpp"

#include <string>
#include <unistd.h>

#define VNA_VID 0x0483
#define VNA_PID 0x5740

bool init_vna_device(VNADevice* vna)
{
    struct sp_port **port_list;

	vna->port = NULL;

	if (sp_list_ports(&port_list) != SP_OK) 
    {
		printf("sp_list_ports() failed!\n");
		return false;
	}

	for (int i = 0; port_list[i] != NULL; i++) 
    {
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
        sp_free_port(vna->port);
        return false;
    }

    // for first command, it also prints intro line, so need to send a cmd
    // now to get rid of that line
    send_cmd_vna_device(vna, "stat");
    sleep(1);
    sp_flush(vna->port, SP_BUF_BOTH);

    return true;
}

void destroy_vna_device(VNADevice* vna)
{
    sp_close(vna->port);
}

bool send_cmd_vna_device(VNADevice* vna, const char* cmd)
{
    std::string temp_cmd(cmd);
    temp_cmd += "\r";

    if(sp_blocking_write(vna->port, temp_cmd.c_str(), temp_cmd.size(), 0) < 0)
    {
        printf("error writing to vna\n");
        return false;
    }
    sp_drain(vna->port);
    return true;
}

void read_data_vna_device(VNADevice* vna, char **buf, size_t* count)
{
    if(!sp_input_waiting(vna->port))
    {
        *count = 0;
        *buf = NULL;
        return;
    }

    size_t bufSize = 100;
    auto tempBuf = static_cast<char*>(malloc(bufSize));
    size_t cnt = 0;

    while(sp_blocking_read(vna->port, tempBuf + cnt, 1, 10))
    {
        ++cnt;
        if(cnt == bufSize)
        {
            bufSize += 100;
            tempBuf = static_cast<char*>(realloc(tempBuf, bufSize));
        }
    }

    const size_t shell_prompt_len = 4;
    size_t first_line_len = 0;
    while(first_line_len < cnt && tempBuf[first_line_len] != '\n')
    {
        ++first_line_len;
    }
    if(first_line_len == cnt || first_line_len + 1 + shell_prompt_len == cnt)
    {
        free(tempBuf);
        *count = 0;
        *buf = NULL;
        return ;
    }

    // trim the first line received as well as the shell prompt at the end
    char* tmp = tempBuf;
    const size_t new_buf_size = cnt - (first_line_len + 1) - shell_prompt_len + 1;
    tempBuf = static_cast<char*>(malloc(new_buf_size));
    snprintf(tempBuf, new_buf_size, "%s", tmp + first_line_len + 1);
    free(tmp);
    *count = new_buf_size;
    *buf = tempBuf;
    return ;
}