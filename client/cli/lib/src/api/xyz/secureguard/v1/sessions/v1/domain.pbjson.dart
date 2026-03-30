// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/sessions/v1/domain.proto.

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

@$core.Deprecated('Use sessionDescriptor instead')
const Session$json = {
  '1': 'Session',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'hash', '3': 2, '4': 1, '5': 9, '10': 'hash'},
    {
      '1': 'revoke',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.sessions.v1.Session.RevokeInfo',
      '9': 0,
      '10': 'revoke',
      '17': true
    },
    {
      '1': 'created_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'expires_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'last_seen',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 1,
      '10': 'lastSeen',
      '17': true
    },
  ],
  '3': [Session_RevokeInfo$json],
  '8': [
    {'1': '_revoke'},
    {'1': '_last_seen'},
  ],
};

@$core.Deprecated('Use sessionDescriptor instead')
const Session_RevokeInfo$json = {
  '1': 'RevokeInfo',
  '2': [
    {'1': 'revoked', '3': 1, '4': 1, '5': 8, '10': 'revoked'},
    {
      '1': 'revoked_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'revokedAt'
    },
  ],
};

/// Descriptor for `Session`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionDescriptor = $convert.base64Decode(
    'CgdTZXNzaW9uEg4KAmlkGAEgASgJUgJpZBISCgRoYXNoGAIgASgJUgRoYXNoEk8KBnJldm9rZR'
    'gDIAEoCzIyLnh5ei5zZWN1cmVndWFyZC52MS5zZXNzaW9ucy52MS5TZXNzaW9uLlJldm9rZUlu'
    'Zm9IAFIGcmV2b2tliAEBEjkKCmNyZWF0ZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgljcmVhdGVkQXQSOQoKZXhwaXJlc19hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCWV4cGlyZXNBdBI8CglsYXN0X3NlZW4YBiABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wSAFSCGxhc3RTZWVuiAEBGmEKClJldm9rZUluZm8SGAoHcmV2b2tlZBgB'
    'IAEoCFIHcmV2b2tlZBI5CgpyZXZva2VkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIJcmV2b2tlZEF0QgkKB19yZXZva2VCDAoKX2xhc3Rfc2Vlbg==');

@$core.Deprecated('Use sessionsListResponseDescriptor instead')
const SessionsListResponse$json = {
  '1': 'SessionsListResponse',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.xyz.secureguard.v1.sessions.v1.Session',
      '10': 'list'
    },
  ],
};

/// Descriptor for `SessionsListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionsListResponseDescriptor = $convert.base64Decode(
    'ChRTZXNzaW9uc0xpc3RSZXNwb25zZRI7CgRsaXN0GAEgAygLMicueHl6LnNlY3VyZWd1YXJkLn'
    'YxLnNlc3Npb25zLnYxLlNlc3Npb25SBGxpc3Q=');
