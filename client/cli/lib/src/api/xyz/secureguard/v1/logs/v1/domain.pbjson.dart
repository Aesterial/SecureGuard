// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/logs/v1/domain.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use kafkaLogEntryDescriptor instead')
const KafkaLogEntry$json = {
  '1': 'KafkaLogEntry',
  '2': [
    {
      '1': 'timestamp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {'1': 'service', '3': 2, '4': 1, '5': 9, '10': 'service'},
    {'1': 'level', '3': 3, '4': 1, '5': 9, '10': 'level'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'fields',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.xyz.secureguard.v1.logs.v1.KafkaLogEntry.FieldsEntry',
      '10': 'fields'
    },
  ],
  '3': [KafkaLogEntry_FieldsEntry$json],
};

@$core.Deprecated('Use kafkaLogEntryDescriptor instead')
const KafkaLogEntry_FieldsEntry$json = {
  '1': 'FieldsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `KafkaLogEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kafkaLogEntryDescriptor = $convert.base64Decode(
    'Cg1LYWZrYUxvZ0VudHJ5EjgKCXRpbWVzdGFtcBgBIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSCXRpbWVzdGFtcBIYCgdzZXJ2aWNlGAIgASgJUgdzZXJ2aWNlEhQKBWxldmVsGAMg'
    'ASgJUgVsZXZlbBIYCgdtZXNzYWdlGAQgASgJUgdtZXNzYWdlEk0KBmZpZWxkcxgFIAMoCzI1Ln'
    'h5ei5zZWN1cmVndWFyZC52MS5sb2dzLnYxLkthZmthTG9nRW50cnkuRmllbGRzRW50cnlSBmZp'
    'ZWxkcxo5CgtGaWVsZHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdm'
    'FsdWU6AjgB');
