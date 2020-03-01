from __future__ import print_function
import logging

import grpc

import pico_vna_pb2
import pico_vna_pb2_grpc


def run():
    with grpc.insecure_channel('192.168.4.1:50051') as channel:
        stub = pico_vna_pb2_grpc.PicoGrpcStub(channel)
        response = stub.RequestData(pico_vna_pb2.DataRequest())
        for resp in response.data:
            print(resp)

if __name__ == '__main__':
    logging.basicConfig()
    run()
