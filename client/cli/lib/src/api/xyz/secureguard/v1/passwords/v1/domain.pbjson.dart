// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/passwords/v1/domain.proto.

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

@$core.Deprecated('Use serviceInfoDescriptor instead')
const ServiceInfo$json = {
  '1': 'ServiceInfo',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `ServiceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceInfoDescriptor = $convert.base64Decode(
    'CgtTZXJ2aWNlSW5mbxIQCgN1cmwYASABKAlSA3VybBISCgRuYW1lGAIgASgJUgRuYW1l');

@$core.Deprecated('Use passwordDescriptor instead')
const Password$json = {
  '1': 'Password',
  '2': [
    {
      '1': 'serv',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.passwords.v1.ServiceInfo',
      '10': 'serv'
    },
    {'1': 'login', '3': 2, '4': 1, '5': 9, '10': 'login'},
    {'1': 'pass', '3': 3, '4': 1, '5': 9, '10': 'pass'},
    {
      '1': 'created_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `Password`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passwordDescriptor = $convert.base64Decode(
    'CghQYXNzd29yZBJACgRzZXJ2GAEgASgLMiwueHl6LnNlY3VyZWd1YXJkLnYxLnBhc3N3b3Jkcy'
    '52MS5TZXJ2aWNlSW5mb1IEc2VydhIUCgVsb2dpbhgCIAEoCVIFbG9naW4SEgoEcGFzcxgDIAEo'
    'CVIEcGFzcxI5CgpjcmVhdGVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IJY3JlYXRlZEF0');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xyz.secureguard.v1.passwords.v1.Password',
      '10': 'list'
    },
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USPQoEbGlzdBgBIAMoCzIpLnh5ei5zZWN1cmVndWFyZC52MS5wYXNzd2'
    '9yZHMudjEuUGFzc3dvcmRSBGxpc3QSFAoFY291bnQYAiABKAVSBWNvdW50');

@$core.Deprecated('Use createRequestDescriptor instead')
const CreateRequest$json = {
  '1': 'CreateRequest',
  '2': [
    {'1': 'service_url', '3': 1, '4': 1, '5': 9, '10': 'serviceUrl'},
    {'1': 'login', '3': 2, '4': 1, '5': 9, '10': 'login'},
    {'1': 'ciphertext', '3': 3, '4': 1, '5': 9, '10': 'ciphertext'},
    {'1': 'version', '3': 4, '4': 1, '5': 5, '10': 'version'},
    {'1': 'nonce', '3': 5, '4': 1, '5': 9, '10': 'nonce'},
    {'1': 'aad', '3': 6, '4': 1, '5': 12, '10': 'aad'},
    {'1': 'metadata', '3': 7, '4': 1, '5': 9, '10': 'metadata'},
  ],
};

/// Descriptor for `CreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRequestDescriptor = $convert.base64Decode(
    'Cg1DcmVhdGVSZXF1ZXN0Eh8KC3NlcnZpY2VfdXJsGAEgASgJUgpzZXJ2aWNlVXJsEhQKBWxvZ2'
    'luGAIgASgJUgVsb2dpbhIeCgpjaXBoZXJ0ZXh0GAMgASgJUgpjaXBoZXJ0ZXh0EhgKB3ZlcnNp'
    'b24YBCABKAVSB3ZlcnNpb24SFAoFbm9uY2UYBSABKAlSBW5vbmNlEhAKA2FhZBgGIAEoDFIDYW'
    'FkEhoKCG1ldGFkYXRhGAcgASgJUghtZXRhZGF0YQ==');

@$core.Deprecated('Use passDataResponseDescriptor instead')
const PassDataResponse$json = {
  '1': 'PassDataResponse',
  '2': [
    {
      '1': 'info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.passwords.v1.Password',
      '10': 'info'
    },
    {
      '1': 'at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
  ],
};

/// Descriptor for `PassDataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List passDataResponseDescriptor = $convert.base64Decode(
    'ChBQYXNzRGF0YVJlc3BvbnNlEj0KBGluZm8YASABKAsyKS54eXouc2VjdXJlZ3VhcmQudjEucG'
    'Fzc3dvcmRzLnYxLlBhc3N3b3JkUgRpbmZvEioKAmF0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFICYXQ=');

@$core.Deprecated('Use updateRequestDescriptor instead')
const UpdateRequest$json = {
  '1': 'UpdateRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {
      '1': 'service_url',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'serviceUrl',
      '17': true
    },
    {'1': 'login', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'login', '17': true},
    {'1': 'pass', '3': 4, '4': 1, '5': 9, '9': 2, '10': 'pass', '17': true},
    {'1': 'salt', '3': 5, '4': 1, '5': 9, '10': 'salt'},
  ],
  '8': [
    {'1': '_service_url'},
    {'1': '_login'},
    {'1': '_pass'},
  ],
};

/// Descriptor for `UpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRequestDescriptor = $convert.base64Decode(
    'Cg1VcGRhdGVSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIkCgtzZXJ2aWNlX3VybBgCIAEoCUgAUg'
    'pzZXJ2aWNlVXJsiAEBEhkKBWxvZ2luGAMgASgJSAFSBWxvZ2luiAEBEhcKBHBhc3MYBCABKAlI'
    'AlIEcGFzc4gBARISCgRzYWx0GAUgASgJUgRzYWx0Qg4KDF9zZXJ2aWNlX3VybEIICgZfbG9naW'
    '5CBwoFX3Bhc3M=');

@$core.Deprecated('Use deleteResponseDescriptor instead')
const DeleteResponse$json = {
  '1': 'DeleteResponse',
};

/// Descriptor for `DeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteResponseDescriptor =
    $convert.base64Decode('Cg5EZWxldGVSZXNwb25zZQ==');
