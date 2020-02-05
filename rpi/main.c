#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <time.h>
#include <stdlib.h>
#include <getopt.h>
#include <unistd.h>
#include <errno.h>

#include "vna_bluetooth.h"
#include "vna_device.h"

int main()
{
    if(geteuid() != 0)
    {
        printf("Program needs to be run as root");
        return EXIT_FAILURE;
    }

    // TODO(khoi): Investigate command delay
    VNADevice vna_dev;
    if(!init_vna_device(&vna_dev))
    {
        // TODO(khoi): Change error handling here
        destroy_vna_device(&vna_dev);
        return EXIT_FAILURE;
    }

    if(!init_vna_bluetooth(&vna_dev))
    {
        return EXIT_FAILURE;
    }

    // main loop of program
    run_vna_bluetooth();

    printf("\n\nShutting down...\n");

    destroy_vna_device(&vna_dev);
}