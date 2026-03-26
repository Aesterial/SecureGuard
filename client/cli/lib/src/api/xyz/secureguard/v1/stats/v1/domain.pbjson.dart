// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/stats/v1/domain.proto.

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

@$core.Deprecated('Use byDateRequestDescriptor instead')
const ByDateRequest$json = {
  '1': 'ByDateRequest',
  '2': [
    {
      '1': 'day',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'day'
    },
  ],
};

/// Descriptor for `ByDateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List byDateRequestDescriptor = $convert.base64Decode(
    'Cg1CeURhdGVSZXF1ZXN0EiwKA2RheRgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSA2RheQ==');

@$core.Deprecated('Use totalResponseDescriptor instead')
const TotalResponse$json = {
  '1': 'TotalResponse',
  '2': [
    {'1': 'users', '3': 1, '4': 1, '5': 5, '10': 'users'},
    {'1': 'admins', '3': 2, '4': 1, '5': 5, '10': 'admins'},
    {'1': 'passwords', '3': 3, '4': 1, '5': 5, '10': 'passwords'},
    {'1': 'active_sessions', '3': 4, '4': 1, '5': 5, '10': 'activeSessions'},
  ],
};

/// Descriptor for `TotalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List totalResponseDescriptor = $convert.base64Decode(
    'Cg1Ub3RhbFJlc3BvbnNlEhQKBXVzZXJzGAEgASgFUgV1c2VycxIWCgZhZG1pbnMYAiABKAVSBm'
    'FkbWlucxIcCglwYXNzd29yZHMYAyABKAVSCXBhc3N3b3JkcxInCg9hY3RpdmVfc2Vzc2lvbnMY'
    'BCABKAVSDmFjdGl2ZVNlc3Npb25z');

@$core.Deprecated('Use graphPointDescriptor instead')
const GraphPoint$json = {
  '1': 'GraphPoint',
  '2': [
    {
      '1': 'time',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'time'
    },
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
};

/// Descriptor for `GraphPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List graphPointDescriptor = $convert.base64Decode(
    'CgpHcmFwaFBvaW50Ei4KBHRpbWUYASABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'R0aW1lEhQKBXZhbHVlGAIgASgFUgV2YWx1ZQ==');

@$core.Deprecated('Use latencyDescriptor instead')
const Latency$json = {
  '1': 'Latency',
  '2': [
    {'1': 'p50', '3': 1, '4': 1, '5': 1, '10': 'p50'},
    {'1': 'p90', '3': 2, '4': 1, '5': 1, '10': 'p90'},
  ],
};

/// Descriptor for `Latency`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List latencyDescriptor = $convert.base64Decode(
    'CgdMYXRlbmN5EhAKA3A1MBgBIAEoAVIDcDUwEhAKA3A5MBgCIAEoAVIDcDkw');

@$core.Deprecated('Use statsDescriptor instead')
const Stats$json = {
  '1': 'Stats',
  '2': [
    {
      '1': 'top_services',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xyz.secureguard.v1.stats.v1.Stats.TopServicesEntry',
      '10': 'topServices'
    },
    {
      '1': 'users_graph',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.xyz.secureguard.v1.stats.v1.GraphPoint',
      '10': 'usersGraph'
    },
    {
      '1': 'register_graph',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.xyz.secureguard.v1.stats.v1.GraphPoint',
      '10': 'registerGraph'
    },
    {
      '1': 'crypt_uses',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.xyz.secureguard.v1.stats.v1.Stats.CryptUsesEntry',
      '10': 'cryptUses'
    },
    {
      '1': 'theme_uses',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.xyz.secureguard.v1.stats.v1.Stats.ThemeUsesEntry',
      '10': 'themeUses'
    },
    {
      '1': 'lang_uses',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.xyz.secureguard.v1.stats.v1.Stats.LangUsesEntry',
      '10': 'langUses'
    },
    {
      '1': 'latency',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.stats.v1.Latency',
      '10': 'latency'
    },
  ],
  '3': [
    Stats_TopServicesEntry$json,
    Stats_CryptUsesEntry$json,
    Stats_ThemeUsesEntry$json,
    Stats_LangUsesEntry$json
  ],
};

@$core.Deprecated('Use statsDescriptor instead')
const Stats_TopServicesEntry$json = {
  '1': 'TopServicesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use statsDescriptor instead')
const Stats_CryptUsesEntry$json = {
  '1': 'CryptUsesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use statsDescriptor instead')
const Stats_ThemeUsesEntry$json = {
  '1': 'ThemeUsesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use statsDescriptor instead')
const Stats_LangUsesEntry$json = {
  '1': 'LangUsesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Stats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statsDescriptor = $convert.base64Decode(
    'CgVTdGF0cxJWCgx0b3Bfc2VydmljZXMYASADKAsyMy54eXouc2VjdXJlZ3VhcmQudjEuc3RhdH'
    'MudjEuU3RhdHMuVG9wU2VydmljZXNFbnRyeVILdG9wU2VydmljZXMSSAoLdXNlcnNfZ3JhcGgY'
    'AyADKAsyJy54eXouc2VjdXJlZ3VhcmQudjEuc3RhdHMudjEuR3JhcGhQb2ludFIKdXNlcnNHcm'
    'FwaBJOCg5yZWdpc3Rlcl9ncmFwaBgCIAMoCzInLnh5ei5zZWN1cmVndWFyZC52MS5zdGF0cy52'
    'MS5HcmFwaFBvaW50Ug1yZWdpc3RlckdyYXBoElAKCmNyeXB0X3VzZXMYBCADKAsyMS54eXouc2'
    'VjdXJlZ3VhcmQudjEuc3RhdHMudjEuU3RhdHMuQ3J5cHRVc2VzRW50cnlSCWNyeXB0VXNlcxJQ'
    'Cgp0aGVtZV91c2VzGAUgAygLMjEueHl6LnNlY3VyZWd1YXJkLnYxLnN0YXRzLnYxLlN0YXRzLl'
    'RoZW1lVXNlc0VudHJ5Ugl0aGVtZVVzZXMSTQoJbGFuZ191c2VzGAYgAygLMjAueHl6LnNlY3Vy'
    'ZWd1YXJkLnYxLnN0YXRzLnYxLlN0YXRzLkxhbmdVc2VzRW50cnlSCGxhbmdVc2VzEj4KB2xhdG'
    'VuY3kYByABKAsyJC54eXouc2VjdXJlZ3VhcmQudjEuc3RhdHMudjEuTGF0ZW5jeVIHbGF0ZW5j'
    'eRo+ChBUb3BTZXJ2aWNlc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgFUg'
    'V2YWx1ZToCOAEaPAoOQ3J5cHRVc2VzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUY'
    'AiABKAVSBXZhbHVlOgI4ARo8Cg5UaGVtZVVzZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCg'
    'V2YWx1ZRgCIAEoBVIFdmFsdWU6AjgBGjsKDUxhbmdVc2VzRW50cnkSEAoDa2V5GAEgASgJUgNr'
    'ZXkSFAoFdmFsdWUYAiABKAVSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use statsResponseDescriptor instead')
const StatsResponse$json = {
  '1': 'StatsResponse',
  '2': [
    {
      '1': 'stats',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.stats.v1.Stats',
      '10': 'stats'
    },
  ],
};

/// Descriptor for `StatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statsResponseDescriptor = $convert.base64Decode(
    'Cg1TdGF0c1Jlc3BvbnNlEjgKBXN0YXRzGAEgASgLMiIueHl6LnNlY3VyZWd1YXJkLnYxLnN0YX'
    'RzLnYxLlN0YXRzUgVzdGF0cw==');
