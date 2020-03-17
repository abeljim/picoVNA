///
//  Generated code. Do not modify.
//  source: pico_vna.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const DataPoint$json = const {
  '1': 'DataPoint',
  '2': const [
    const {'1': 'real', '3': 1, '4': 1, '5': 2, '10': 'real'},
    const {'1': 'im', '3': 2, '4': 1, '5': 2, '10': 'im'},
  ],
};

const ScanRequest$json = const {
  '1': 'ScanRequest',
  '2': const [
    const {'1': 'start', '3': 1, '4': 1, '5': 5, '10': 'start'},
    const {'1': 'stop', '3': 2, '4': 1, '5': 5, '10': 'stop'},
  ],
};

const ScanReply$json = const {
  '1': 'ScanReply',
  '2': const [
    const {'1': 'freqs', '3': 1, '4': 3, '5': 2, '10': 'freqs'},
    const {'1': 's11_data', '3': 2, '4': 3, '5': 11, '6': '.picogrpc.DataPoint', '10': 's11Data'},
    const {'1': 's21_data', '3': 3, '4': 3, '5': 11, '6': '.picogrpc.DataPoint', '10': 's21Data'},
  ],
};

