from concurrent import futures
import logging

import grpc

import pico_vna_pb2 
import pico_vna_pb2_grpc

import serial
# import numpy as np
# import pylab as pl
from serial.tools import list_ports

VID = 0x0483 #1155
PID = 0x5740 #22336

# Get nanovna device automatically
def getport() -> str:
    device_list = list_ports.comports()
    for device in device_list:
        if device.vid == VID and device.pid == PID:
            return device.device
    raise OSError("device not found")

REF_LEVEL = (1<<9)

def isfloat(value):
  try:
    float(value)
    return True
  except ValueError:
    return False

class NanoVNA:
    def __init__(self, dev = None):
        self.dev = dev or getport()
        self.serial = None
        self._frequencies = None
        self.points = 101

        # used for clearing the serial buffer
        self.send_command("stat\r")
        
    @property
    def frequencies(self):
        return self._frequencies

    def open(self):
        if self.serial is None:
            self.serial = serial.Serial(self.dev)

    def close(self):
        if self.serial:
            self.serial.close()
        self.serial = None

    def send_command(self, cmd):
        self.open()
        self.serial.reset_input_buffer()
        self.serial.write(cmd.encode())
        self.serial.readline() # discard empty line

    def set_sweep(self, start, stop):
        if start is not None:
            self.send_command("sweep start %d\r" % start)
        if stop is not None:
            self.send_command("sweep stop %d\r" % stop)

    def set_frequency(self, freq):
        if freq is not None:
            self.send_command("freq %d\r" % freq)

    def set_port(self, port):
        if port is not None:
            self.send_command("port %d\r" % port)

    def set_gain(self, gain):
        if gain is not None:
            self.send_command("gain %d %d\r" % (gain, gain))

    def set_offset(self, offset):
        if offset is not None:
            self.send_command("offset %d\r" % offset)

    def set_strength(self, strength):
        if strength is not None:
            self.send_command("power %d\r" % strength)

    def set_filter(self, filter):
        self.filter = filter

    def fetch_data(self):
        result = ''
        line = ''
        while True:
            c = self.serial.read().decode('utf-8')
            if c == chr(13):
                next # ignore CR
            line += c
            if c == chr(10):
                result += line
                line = ''
                next
            if line.endswith('ch>'):
                # stop on prompt
                break
        return result

    def fetch_array(self):
        self.send_command("data 0\r")
        data = self.fetch_data()
        x = []
        for line in data.split('\n'):
            if line:
                temp = line.strip().split(' ')
                if len(temp) == 2 and isfloat(temp[0]) and isfloat(temp[1]):
                    x.append(pico_vna_pb2.DataPoint(real=float(temp[0]), im=float(temp[1])))
        return x

    def fetch_gamma(self, freq = None):
        if freq:
            self.set_frequency(freq)
        self.send_command("gamma\r")
        data = self.serial.readline()
        d = data.strip().split(' ')
        return (int(d[0])+int(d[1])*1.j)/REF_LEVEL

    def resume(self):
        self.send_command("resume\r")
    
    def pause(self):
        self.send_command("pause\r")
    
    def data(self, array = 0):
        self.send_command("data %d\r" % array)
        data = self.fetch_data()
        x = []
        for line in data.split('\n'):
            if line:
                d = line.strip().split(' ')
                x.append(pico_vna_pb2.DataPoint(real=float(d[0]), im=float(d[1])))
        return x

    def fetch_frequencies(self):
        self.send_command("frequencies\r")
        data = self.fetch_data()
        x = []
        for line in data.split('\n'):
            if line:
                x.append(float(line))
        
        return x

    def scan(self):
        segment_length = 101
        array0 = []
        array1 = []

        freqs = self.fetch_frequencies()
        while len(freqs) > 0:
            start = freqs[0]
            stop = freqs[min(segment_length, len(freqs))-1]
            length = min(segment_length, len(freqs))

            self.send_scan(start, stop, length)
            array0.extend(self.data(0))
            array1.extend(self.data(1))
            freqs = freqs[segment_length:]

        self.resume()
        return (array0, array1)

    def send_scan(self, start = 1e6, stop = 900e6, points = None):
        if points:
            self.send_command("scan %d %d %d\r"%(start, stop, points))
        else:
            self.send_command("scan %d %d\r"%(start, stop))

nv = NanoVNA(getport())

class PicoGrpc(pico_vna_pb2_grpc.PicoGrpcServicer):
    def RequestScan(self, request, context):
        global nv
        # data = nv.fetch_array()
        # # sometimes the fetch returns nothing
        # while data == []:
        #     data = nv.fetch_array()
        data = nv.scan()
        return pico_vna_pb2.ScanReply(freqs=nv.fetch_frequencies(), s11_data=data[0], s21_data=data[1])

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    pico_vna_pb2_grpc.add_PicoGrpcServicer_to_server(PicoGrpc(), server)
    server.add_insecure_port('[::]:50051')
    print("starting grpc server")
    server.start()
    server.wait_for_termination()


if __name__ == '__main__':
    logging.basicConfig()
    serve()
