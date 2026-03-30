// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/login/v1/domain.proto.

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

@$core.Deprecated('Use authorizeRequestDescriptor instead')
const AuthorizeRequest$json = {
  '1': 'AuthorizeRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'master_key', '3': 3, '4': 1, '5': 9, '10': 'masterKey'},
  ],
};

/// Descriptor for `AuthorizeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorizeRequestDescriptor = $convert.base64Decode(
    'ChBBdXRob3JpemVSZXF1ZXN0EhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIaCghwYXNzd2'
    '9yZBgCIAEoCVIIcGFzc3dvcmQSHQoKbWFzdGVyX2tleRgDIAEoCVIJbWFzdGVyS2V5');

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'master_key', '3': 3, '4': 1, '5': 9, '10': 'masterKey'},
    {'1': 'salt', '3': 4, '4': 1, '5': 9, '10': 'salt'},
    {
      '1': 'kdf_params',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.Kdf',
      '10': 'kdfParams'
    },
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclJlcXVlc3QSGgoIdXNlcm5hbWUYASABKAlSCHVzZXJuYW1lEhoKCHBhc3N3b3'
    'JkGAIgASgJUghwYXNzd29yZBIdCgptYXN0ZXJfa2V5GAMgASgJUgltYXN0ZXJLZXkSEgoEc2Fs'
    'dBgEIAEoCVIEc2FsdBI2CgprZGZfcGFyYW1zGAUgASgLMhcueHl6LnNlY3VyZWd1YXJkLnYxLk'
    'tkZlIJa2RmUGFyYW1z');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {
      '1': 'info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.users.v1.UserSelf',
      '10': 'info'
    },
    {'1': 'session', '3': 2, '4': 1, '5': 9, '10': 'session'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEjkKBGluZm8YASABKAsyJS54eXouc2VjdXJlZ3VhcmQudjEudXNlcn'
    'MudjEuVXNlclNlbGZSBGluZm8SGAoHc2Vzc2lvbhgCIAEoCVIHc2Vzc2lvbg==');
