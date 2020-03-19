#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <time.h>
#include <stdlib.h>
#include <getopt.h>
#include <unistd.h>
#include <errno.h>
#include <assert.h>

#define USB_ONLY

#ifndef USB_ONLY
#include "vna_bluetooth.h"
#endif
#include "vna_device.hpp"

int main()
{
    #ifndef USB_ONLY
    {
        if(geteuid() != 0)
        {
            printf("Program needs to be run as root\n");
            return EXIT_FAILURE;
        }
    }
    #endif

    // TODO(khoi): Investigate command delay
    VNADevice vna_dev;
    if(!init_vna_device(&vna_dev))
    {
        return EXIT_FAILURE;
    }

    #ifndef USB_ONLY
    {
        if(!init_vna_bluetooth(&vna_dev))
        {
            return EXIT_FAILURE;
        }

        // main loop of program
        run_vna_bluetooth();
    }
    #endif

    printf("\nShutting down...\n");

    destroy_vna_device(&vna_dev);
}