#ifndef _VNA_BLUETOOTH_H
#define _VNA_BLUETOOTH_H

#include "vna_device.hpp"
#ifdef __cplusplus
extern "C" {
#endif

bool init_vna_bluetooth(VNADevice* vna_dev);
void run_vna_bluetooth();

#ifdef __cplusplus
}
#endif
#endif // ! _VNA_BLUETOOTH_H