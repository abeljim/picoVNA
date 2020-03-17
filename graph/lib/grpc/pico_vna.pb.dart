///
//  Generated code. Do not modify.
//  source: pico_vna.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DataPoint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DataPoint', package: const $pb.PackageName('picogrpc'), createEmptyInstance: create)
    ..a<$core.double>(1, 'real', $pb.PbFieldType.OF)
    ..a<$core.double>(2, 'im', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  DataPoint._() : super();
  factory DataPoint() => create();
  factory DataPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DataPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DataPoint clone() => DataPoint()..mergeFromMessage(this);
  DataPoint copyWith(void Function(DataPoint) updates) => super.copyWith((message) => updates(message as DataPoint));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DataPoint create() => DataPoint._();
  DataPoint createEmptyInstance() => create();
  static $pb.PbList<DataPoint> createRepeated() => $pb.PbList<DataPoint>();
  @$core.pragma('dart2js:noInline')
  static DataPoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataPoint>(create);
  static DataPoint _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get real => $_getN(0);
  @$pb.TagNumber(1)
  set real($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasReal() => $_has(0);
  @$pb.TagNumber(1)
  void clearReal() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get im => $_getN(1);
  @$pb.TagNumber(2)
  set im($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIm() => $_has(1);
  @$pb.TagNumber(2)
  void clearIm() => clearField(2);
}

class ScanRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ScanRequest', package: const $pb.PackageName('picogrpc'), createEmptyInstance: create)
    ..a<$core.int>(1, 'start', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'stop', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ScanRequest._() : super();
  factory ScanRequest() => create();
  factory ScanRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ScanRequest clone() => ScanRequest()..mergeFromMessage(this);
  ScanRequest copyWith(void Function(ScanRequest) updates) => super.copyWith((message) => updates(message as ScanRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScanRequest create() => ScanRequest._();
  ScanRequest createEmptyInstance() => create();
  static $pb.PbList<ScanRequest> createRepeated() => $pb.PbList<ScanRequest>();
  @$core.pragma('dart2js:noInline')
  static ScanRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanRequest>(create);
  static ScanRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get start => $_getIZ(0);
  @$pb.TagNumber(1)
  set start($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get stop => $_getIZ(1);
  @$pb.TagNumber(2)
  set stop($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStop() => $_has(1);
  @$pb.TagNumber(2)
  void clearStop() => clearField(2);
}

class ScanReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ScanReply', package: const $pb.PackageName('picogrpc'), createEmptyInstance: create)
    ..p<$core.double>(1, 'freqs', $pb.PbFieldType.PF)
    ..pc<DataPoint>(2, 's11Data', $pb.PbFieldType.PM, subBuilder: DataPoint.create)
    ..pc<DataPoint>(3, 's21Data', $pb.PbFieldType.PM, subBuilder: DataPoint.create)
    ..hasRequiredFields = false
  ;

  ScanReply._() : super();
  factory ScanReply() => create();
  factory ScanReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ScanReply clone() => ScanReply()..mergeFromMessage(this);
  ScanReply copyWith(void Function(ScanReply) updates) => super.copyWith((message) => updates(message as ScanReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScanReply create() => ScanReply._();
  ScanReply createEmptyInstance() => create();
  static $pb.PbList<ScanReply> createRepeated() => $pb.PbList<ScanReply>();
  @$core.pragma('dart2js:noInline')
  static ScanReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanReply>(create);
  static ScanReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.double> get freqs => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<DataPoint> get s11Data => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<DataPoint> get s21Data => $_getList(2);
}

