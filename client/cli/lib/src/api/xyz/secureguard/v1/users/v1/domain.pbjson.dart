// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/users/v1/domain.proto.

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

@$core.Deprecated('Use themeDescriptor instead')
const Theme$json = {
  '1': 'Theme',
  '2': [
    {'1': 'THEME_UNSPECIFIED', '2': 0},
    {'1': 'THEME_WHITE', '2': 1},
    {'1': 'THEME_BLACK', '2': 2},
  ],
};

/// Descriptor for `Theme`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List themeDescriptor = $convert.base64Decode(
    'CgVUaGVtZRIVChFUSEVNRV9VTlNQRUNJRklFRBAAEg8KC1RIRU1FX1dISVRFEAESDwoLVEhFTU'
    'VfQkxBQ0sQAg==');

@$core.Deprecated('Use languageDescriptor instead')
const Language$json = {
  '1': 'Language',
  '2': [
    {'1': 'LANGUAGE_UNSPECIFIED', '2': 0},
    {'1': 'LANGUAGE_RU', '2': 1},
    {'1': 'LANGUAGE_EN', '2': 2},
  ],
};

/// Descriptor for `Language`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List languageDescriptor = $convert.base64Decode(
    'CghMYW5ndWFnZRIYChRMQU5HVUFHRV9VTlNQRUNJRklFRBAAEg8KC0xBTkdVQUdFX1JVEAESDw'
    'oLTEFOR1VBR0VfRU4QAg==');

@$core.Deprecated('Use cryptDescriptor instead')
const Crypt$json = {
  '1': 'Crypt',
  '2': [
    {'1': 'CRYPT_UNSPECIFIED', '2': 0},
    {'1': 'CRYPT_ARGON2ID', '2': 1},
    {'1': 'CRYPT_SHA256', '2': 2},
  ],
};

/// Descriptor for `Crypt`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cryptDescriptor = $convert.base64Decode(
    'CgVDcnlwdBIVChFDUllQVF9VTlNQRUNJRklFRBAAEhIKDkNSWVBUX0FSR09OMklEEAESEAoMQ1'
    'JZUFRfU0hBMjU2EAI=');

@$core.Deprecated('Use preferencesDescriptor instead')
const Preferences$json = {
  '1': 'Preferences',
  '2': [
    {
      '1': 'theme',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Theme',
      '10': 'theme'
    },
    {
      '1': 'lang',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Language',
      '10': 'lang'
    },
    {
      '1': 'crypto',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Crypt',
      '10': 'crypto'
    },
  ],
};

/// Descriptor for `Preferences`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preferencesDescriptor = $convert.base64Decode(
    'CgtQcmVmZXJlbmNlcxI4CgV0aGVtZRgBIAEoDjIiLnh5ei5zZWN1cmVndWFyZC52MS51c2Vycy'
    '52MS5UaGVtZVIFdGhlbWUSOQoEbGFuZxgCIAEoDjIlLnh5ei5zZWN1cmVndWFyZC52MS51c2Vy'
    'cy52MS5MYW5ndWFnZVIEbGFuZxI6CgZjcnlwdG8YAyABKA4yIi54eXouc2VjdXJlZ3VhcmQudj'
    'EudXNlcnMudjEuQ3J5cHRSBmNyeXB0bw==');

@$core.Deprecated('Use userSelfDescriptor instead')
const UserSelf$json = {
  '1': 'UserSelf',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {
      '1': 'joined',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'joined'
    },
    {'1': 'staff', '3': 4, '4': 1, '5': 8, '10': 'staff'},
    {'1': 'phrase', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'phrase', '17': true},
    {
      '1': 'preferences',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.users.v1.Preferences',
      '10': 'preferences'
    },
  ],
  '8': [
    {'1': '_phrase'},
  ],
};

/// Descriptor for `UserSelf`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userSelfDescriptor = $convert.base64Decode(
    'CghVc2VyU2VsZhIOCgJpZBgBIAEoCVICaWQSGgoIdXNlcm5hbWUYAiABKAlSCHVzZXJuYW1lEj'
    'IKBmpvaW5lZBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBmpvaW5lZBIUCgVz'
    'dGFmZhgEIAEoCFIFc3RhZmYSGwoGcGhyYXNlGAUgASgJSABSBnBocmFzZYgBARJKCgtwcmVmZX'
    'JlbmNlcxgGIAEoCzIoLnh5ei5zZWN1cmVndWFyZC52MS51c2Vycy52MS5QcmVmZXJlbmNlc1IL'
    'cHJlZmVyZW5jZXNCCQoHX3BocmFzZQ==');

@$core.Deprecated('Use userPublicDescriptor instead')
const UserPublic$json = {
  '1': 'UserPublic',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'username', '3': 2, '4': 1, '5': 9, '10': 'username'},
    {
      '1': 'lang',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Language',
      '10': 'lang'
    },
    {
      '1': 'crypt',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Crypt',
      '10': 'crypt'
    },
    {'1': 'phrase_set', '3': 5, '4': 1, '5': 8, '10': 'phraseSet'},
  ],
};

/// Descriptor for `UserPublic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userPublicDescriptor = $convert.base64Decode(
    'CgpVc2VyUHVibGljEg4KAmlkGAEgASgJUgJpZBIaCgh1c2VybmFtZRgCIAEoCVIIdXNlcm5hbW'
    'USOQoEbGFuZxgDIAEoDjIlLnh5ei5zZWN1cmVndWFyZC52MS51c2Vycy52MS5MYW5ndWFnZVIE'
    'bGFuZxI4CgVjcnlwdBgEIAEoDjIiLnh5ei5zZWN1cmVndWFyZC52MS51c2Vycy52MS5DcnlwdF'
    'IFY3J5cHQSHQoKcGhyYXNlX3NldBgFIAEoCFIJcGhyYXNlU2V0');

@$core.Deprecated('Use userResponseDescriptor instead')
const UserResponse$json = {
  '1': 'UserResponse',
  '2': [
    {
      '1': 'info',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.xyz.secureguard.v1.users.v1.UserSelf',
      '10': 'info'
    },
  ],
};

/// Descriptor for `UserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userResponseDescriptor = $convert.base64Decode(
    'CgxVc2VyUmVzcG9uc2USOQoEaW5mbxgBIAEoCzIlLnh5ei5zZWN1cmVndWFyZC52MS51c2Vycy'
    '52MS5Vc2VyU2VsZlIEaW5mbw==');

@$core.Deprecated('Use changeThemeRequestDescriptor instead')
const ChangeThemeRequest$json = {
  '1': 'ChangeThemeRequest',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Theme',
      '10': 'value'
    },
  ],
};

/// Descriptor for `ChangeThemeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeThemeRequestDescriptor = $convert.base64Decode(
    'ChJDaGFuZ2VUaGVtZVJlcXVlc3QSOAoFdmFsdWUYASABKA4yIi54eXouc2VjdXJlZ3VhcmQudj'
    'EudXNlcnMudjEuVGhlbWVSBXZhbHVl');

@$core.Deprecated('Use changeLanguageRequestDescriptor instead')
const ChangeLanguageRequest$json = {
  '1': 'ChangeLanguageRequest',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Language',
      '10': 'value'
    },
  ],
};

/// Descriptor for `ChangeLanguageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeLanguageRequestDescriptor = $convert.base64Decode(
    'ChVDaGFuZ2VMYW5ndWFnZVJlcXVlc3QSOwoFdmFsdWUYASABKA4yJS54eXouc2VjdXJlZ3Vhcm'
    'QudjEudXNlcnMudjEuTGFuZ3VhZ2VSBXZhbHVl');

@$core.Deprecated('Use changeCryptRequestDescriptor instead')
const ChangeCryptRequest$json = {
  '1': 'ChangeCryptRequest',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Crypt',
      '10': 'value'
    },
  ],
};

/// Descriptor for `ChangeCryptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeCryptRequestDescriptor = $convert.base64Decode(
    'ChJDaGFuZ2VDcnlwdFJlcXVlc3QSOAoFdmFsdWUYASABKA4yIi54eXouc2VjdXJlZ3VhcmQudj'
    'EudXNlcnMudjEuQ3J5cHRSBXZhbHVl');

@$core.Deprecated('Use changeThemeResponseDescriptor instead')
const ChangeThemeResponse$json = {
  '1': 'ChangeThemeResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Theme',
      '10': 'result'
    },
  ],
};

/// Descriptor for `ChangeThemeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeThemeResponseDescriptor = $convert.base64Decode(
    'ChNDaGFuZ2VUaGVtZVJlc3BvbnNlEjoKBnJlc3VsdBgBIAEoDjIiLnh5ei5zZWN1cmVndWFyZC'
    '52MS51c2Vycy52MS5UaGVtZVIGcmVzdWx0');

@$core.Deprecated('Use changeLanguageResponseDescriptor instead')
const ChangeLanguageResponse$json = {
  '1': 'ChangeLanguageResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Language',
      '10': 'result'
    },
  ],
};

/// Descriptor for `ChangeLanguageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeLanguageResponseDescriptor =
    $convert.base64Decode(
        'ChZDaGFuZ2VMYW5ndWFnZVJlc3BvbnNlEj0KBnJlc3VsdBgBIAEoDjIlLnh5ei5zZWN1cmVndW'
        'FyZC52MS51c2Vycy52MS5MYW5ndWFnZVIGcmVzdWx0');

@$core.Deprecated('Use changeCryptResponseDescriptor instead')
const ChangeCryptResponse$json = {
  '1': 'ChangeCryptResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.xyz.secureguard.v1.users.v1.Crypt',
      '10': 'result'
    },
  ],
};

/// Descriptor for `ChangeCryptResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeCryptResponseDescriptor = $convert.base64Decode(
    'ChNDaGFuZ2VDcnlwdFJlc3BvbnNlEjoKBnJlc3VsdBgBIAEoDjIiLnh5ei5zZWN1cmVndWFyZC'
    '52MS51c2Vycy52MS5DcnlwdFIGcmVzdWx0');

@$core.Deprecated('Use valueChangeResponseDescriptor instead')
const ValueChangeResponse$json = {
  '1': 'ValueChangeResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'result'
    },
  ],
};

/// Descriptor for `ValueChangeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List valueChangeResponseDescriptor = $convert.base64Decode(
    'ChNWYWx1ZUNoYW5nZVJlc3BvbnNlEiwKBnJlc3VsdBgBIAEoCzIULmdvb2dsZS5wcm90b2J1Zi'
    '5BbnlSBnJlc3VsdA==');
