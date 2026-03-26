// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/types.proto.

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

@$core.Deprecated('Use requestWithIDDescriptor instead')
const RequestWithID$json = {
  '1': 'RequestWithID',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `RequestWithID`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWithIDDescriptor =
    $convert.base64Decode('Cg1SZXF1ZXN0V2l0aElEEg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use requestWithIdAndValueDescriptor instead')
const RequestWithIdAndValue$json = {
  '1': 'RequestWithIdAndValue',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `RequestWithIdAndValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWithIdAndValueDescriptor = $convert.base64Decode(
    'ChVSZXF1ZXN0V2l0aElkQW5kVmFsdWUSDgoCaWQYASABKAlSAmlkEhQKBXZhbHVlGAIgASgJUg'
    'V2YWx1ZQ==');

@$core.Deprecated('Use requestWithValueDescriptor instead')
const RequestWithValue$json = {
  '1': 'RequestWithValue',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `RequestWithValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWithValueDescriptor = $convert
    .base64Decode('ChBSZXF1ZXN0V2l0aFZhbHVlEhQKBXZhbHVlGAEgASgJUgV2YWx1ZQ==');

@$core.Deprecated('Use requestWithLimitDescriptor instead')
const RequestWithLimit$json = {
  '1': 'RequestWithLimit',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `RequestWithLimit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWithLimitDescriptor = $convert
    .base64Decode('ChBSZXF1ZXN0V2l0aExpbWl0EhQKBWxpbWl0GAEgASgFUgVsaW1pdA==');

@$core.Deprecated('Use requestWithOffsetDescriptor instead')
const RequestWithOffset$json = {
  '1': 'RequestWithOffset',
  '2': [
    {'1': 'offset', '3': 1, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `RequestWithOffset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWithOffsetDescriptor = $convert.base64Decode(
    'ChFSZXF1ZXN0V2l0aE9mZnNldBIWCgZvZmZzZXQYASABKAVSBm9mZnNldA==');

@$core.Deprecated('Use requestWithLimitAndOffsetDescriptor instead')
const RequestWithLimitAndOffset$json = {
  '1': 'RequestWithLimitAndOffset',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `RequestWithLimitAndOffset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWithLimitAndOffsetDescriptor =
    $convert.base64Decode(
        'ChlSZXF1ZXN0V2l0aExpbWl0QW5kT2Zmc2V0EhQKBWxpbWl0GAEgASgFUgVsaW1pdBIWCgZvZm'
        'ZzZXQYAiABKAVSBm9mZnNldA==');

@$core.Deprecated('Use requestWithBooleanDescriptor instead')
const RequestWithBoolean$json = {
  '1': 'RequestWithBoolean',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 8, '10': 'value'},
  ],
};

/// Descriptor for `RequestWithBoolean`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWithBooleanDescriptor = $convert
    .base64Decode('ChJSZXF1ZXN0V2l0aEJvb2xlYW4SFAoFdmFsdWUYASABKAhSBXZhbHVl');

@$core.Deprecated('Use requestWithBooleanLimitOffsetDescriptor instead')
const RequestWithBooleanLimitOffset$json = {
  '1': 'RequestWithBooleanLimitOffset',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 8, '10': 'value'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `RequestWithBooleanLimitOffset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWithBooleanLimitOffsetDescriptor =
    $convert.base64Decode(
        'Ch1SZXF1ZXN0V2l0aEJvb2xlYW5MaW1pdE9mZnNldBIUCgV2YWx1ZRgBIAEoCFIFdmFsdWUSFA'
        'oFbGltaXQYAiABKAVSBWxpbWl0EhYKBm9mZnNldBgDIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use kdfDescriptor instead')
const Kdf$json = {
  '1': 'Kdf',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    {'1': 'memory', '3': 2, '4': 1, '5': 3, '10': 'memory'},
    {'1': 'iterations', '3': 3, '4': 1, '5': 5, '10': 'iterations'},
    {'1': 'parallelism', '3': 4, '4': 1, '5': 5, '10': 'parallelism'},
  ],
};

/// Descriptor for `Kdf`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kdfDescriptor = $convert.base64Decode(
    'CgNLZGYSGAoHdmVyc2lvbhgBIAEoBVIHdmVyc2lvbhIWCgZtZW1vcnkYAiABKANSBm1lbW9yeR'
    'IeCgppdGVyYXRpb25zGAMgASgFUgppdGVyYXRpb25zEiAKC3BhcmFsbGVsaXNtGAQgASgFUgtw'
    'YXJhbGxlbGlzbQ==');

@$core.Deprecated('Use requestWithValueAndKdfDescriptor instead')
const RequestWithValueAndKdf$json = {
  '1': 'RequestWithValueAndKdf',
  '2': [
    {
      '1': 'kdf',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.Kdf',
      '10': 'kdf'
    },
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `RequestWithValueAndKdf`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestWithValueAndKdfDescriptor =
    $convert.base64Decode(
        'ChZSZXF1ZXN0V2l0aFZhbHVlQW5kS2RmEikKA2tkZhgBIAEoCzIXLnh5ei5zZWN1cmVndWFyZC'
        '52MS5LZGZSA2tkZhIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU=');
