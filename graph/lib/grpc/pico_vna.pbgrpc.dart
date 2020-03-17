///
//  Generated code. Do not modify.
//  source: pico_vna.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'pico_vna.pb.dart' as $0;
export 'pico_vna.pb.dart';

class PicoGrpcClient extends $grpc.Client {
  static final _$requestScan = $grpc.ClientMethod<$0.ScanRequest, $0.ScanReply>(
      '/picogrpc.PicoGrpc/RequestScan',
      ($0.ScanRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ScanReply.fromBuffer(value));

  PicoGrpcClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.ScanReply> requestScan($0.ScanRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$requestScan, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class PicoGrpcServiceBase extends $grpc.Service {
  $core.String get $name => 'picogrpc.PicoGrpc';

  PicoGrpcServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ScanRequest, $0.ScanReply>(
        'RequestScan',
        requestScan_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ScanRequest.fromBuffer(value),
        ($0.ScanReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.ScanReply> requestScan_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ScanRequest> request) async {
    return requestScan(call, await request);
  }

  $async.Future<$0.ScanReply> requestScan(
      $grpc.ServiceCall call, $0.ScanRequest request);
}
