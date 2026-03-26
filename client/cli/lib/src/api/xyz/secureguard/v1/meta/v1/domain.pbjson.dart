// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/meta/v1/domain.proto.

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

@$core.Deprecated('Use clientTypeDescriptor instead')
const ClientType$json = {
  '1': 'ClientType',
  '2': [
    {'1': 'CLIENT_TYPE_SECUREGUARD_UNSPECIFIED', '2': 0},
    {'1': 'CLIENT_TYPE_SECUREGUARD_WINDOWS', '2': 1},
    {'1': 'CLIENT_TYPE_SECUREGUARD_MAC', '2': 2},
    {'1': 'CLIENT_TYPE_SECUREGUARD_LINUX', '2': 3},
    {'1': 'CLIENT_TYPE_SECUREGUARD_ANDROID', '2': 4},
    {'1': 'CLIENT_TYPE_SECUREGUARD_IOS', '2': 5},
  ],
};

/// Descriptor for `ClientType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List clientTypeDescriptor = $convert.base64Decode(
    'CgpDbGllbnRUeXBlEicKI0NMSUVOVF9UWVBFX1NFQ1VSRUdVQVJEX1VOU1BFQ0lGSUVEEAASIw'
    'ofQ0xJRU5UX1RZUEVfU0VDVVJFR1VBUkRfV0lORE9XUxABEh8KG0NMSUVOVF9UWVBFX1NFQ1VS'
    'RUdVQVJEX01BQxACEiEKHUNMSUVOVF9UWVBFX1NFQ1VSRUdVQVJEX0xJTlVYEAMSIwofQ0xJRU'
    '5UX1RZUEVfU0VDVVJFR1VBUkRfQU5EUk9JRBAEEh8KG0NMSUVOVF9UWVBFX1NFQ1VSRUdVQVJE'
    'X0lPUxAF');

@$core.Deprecated('Use serverInfoDescriptor instead')
const ServerInfo$json = {
  '1': 'ServerInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'runtime_version', '3': 3, '4': 1, '5': 9, '10': 'runtimeVersion'},
    {'1': 'supporing_ver', '3': 4, '4': 3, '5': 2, '10': 'supporingVer'},
    {'1': 'commit_hash', '3': 5, '4': 1, '5': 9, '10': 'commitHash'},
    {'1': 'reporitory', '3': 6, '4': 1, '5': 9, '10': 'reporitory'},
    {
      '1': 'build_time',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'buildTime'
    },
  ],
};

/// Descriptor for `ServerInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverInfoDescriptor = $convert.base64Decode(
    'CgpTZXJ2ZXJJbmZvEhIKBG5hbWUYASABKAlSBG5hbWUSGAoHdmVyc2lvbhgCIAEoCVIHdmVyc2'
    'lvbhInCg9ydW50aW1lX3ZlcnNpb24YAyABKAlSDnJ1bnRpbWVWZXJzaW9uEiMKDXN1cHBvcmlu'
    'Z192ZXIYBCADKAJSDHN1cHBvcmluZ1ZlchIfCgtjb21taXRfaGFzaBgFIAEoCVIKY29tbWl0SG'
    'FzaBIeCgpyZXBvcml0b3J5GAYgASgJUgpyZXBvcml0b3J5EjkKCmJ1aWxkX3RpbWUYByABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglidWlsZFRpbWU=');

@$core.Deprecated('Use serverInfoResponseDescriptor instead')
const ServerInfoResponse$json = {
  '1': 'ServerInfoResponse',
  '2': [
    {
      '1': 'info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.api.v1.meta.v1.ServerInfo',
      '10': 'info'
    },
  ],
};

/// Descriptor for `ServerInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverInfoResponseDescriptor = $convert.base64Decode(
    'ChJTZXJ2ZXJJbmZvUmVzcG9uc2USPgoEaW5mbxgBIAEoCzIqLnh5ei5zZWN1cmVndWFyZC5hcG'
    'kudjEubWV0YS52MS5TZXJ2ZXJJbmZvUgRpbmZv');

@$core.Deprecated('Use compatibilityRequestDescriptor instead')
const CompatibilityRequest$json = {
  '1': 'CompatibilityRequest',
  '2': [
    {
      '1': 'client_api_version',
      '3': 1,
      '4': 1,
      '5': 2,
      '10': 'clientApiVersion'
    },
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.api.v1.meta.v1.ClientType',
      '10': 'type'
    },
  ],
};

/// Descriptor for `CompatibilityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compatibilityRequestDescriptor = $convert.base64Decode(
    'ChRDb21wYXRpYmlsaXR5UmVxdWVzdBIsChJjbGllbnRfYXBpX3ZlcnNpb24YASABKAJSEGNsaW'
    'VudEFwaVZlcnNpb24SPgoEdHlwZRgCIAEoDjIqLnh5ei5zZWN1cmVndWFyZC5hcGkudjEubWV0'
    'YS52MS5DbGllbnRUeXBlUgR0eXBl');

@$core.Deprecated('Use compatibilityResponseDescriptor instead')
const CompatibilityResponse$json = {
  '1': 'CompatibilityResponse',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 8, '10': 'value'},
    {'1': 'reasons', '3': 2, '4': 3, '5': 9, '10': 'reasons'},
  ],
};

/// Descriptor for `CompatibilityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compatibilityResponseDescriptor = $convert.base64Decode(
    'ChVDb21wYXRpYmlsaXR5UmVzcG9uc2USFAoFdmFsdWUYASABKAhSBXZhbHVlEhgKB3JlYXNvbn'
    'MYAiADKAlSB3JlYXNvbnM=');
