// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/users/v1/domain.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Theme extends $pb.ProtobufEnum {
  static const Theme THEME_UNSPECIFIED =
      Theme._(0, _omitEnumNames ? '' : 'THEME_UNSPECIFIED');
  static const Theme THEME_WHITE =
      Theme._(1, _omitEnumNames ? '' : 'THEME_WHITE');
  static const Theme THEME_BLACK =
      Theme._(2, _omitEnumNames ? '' : 'THEME_BLACK');

  static const $core.List<Theme> values = <Theme>[
    THEME_UNSPECIFIED,
    THEME_WHITE,
    THEME_BLACK,
  ];

  static final $core.List<Theme?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Theme? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Theme._(super.value, super.name);
}

class Language extends $pb.ProtobufEnum {
  static const Language LANGUAGE_UNSPECIFIED =
      Language._(0, _omitEnumNames ? '' : 'LANGUAGE_UNSPECIFIED');
  static const Language LANGUAGE_RU =
      Language._(1, _omitEnumNames ? '' : 'LANGUAGE_RU');
  static const Language LANGUAGE_EN =
      Language._(2, _omitEnumNames ? '' : 'LANGUAGE_EN');

  static const $core.List<Language> values = <Language>[
    LANGUAGE_UNSPECIFIED,
    LANGUAGE_RU,
    LANGUAGE_EN,
  ];

  static final $core.List<Language?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Language? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Language._(super.value, super.name);
}

class Crypt extends $pb.ProtobufEnum {
  static const Crypt CRYPT_UNSPECIFIED =
      Crypt._(0, _omitEnumNames ? '' : 'CRYPT_UNSPECIFIED');
  static const Crypt CRYPT_ARGON2ID =
      Crypt._(1, _omitEnumNames ? '' : 'CRYPT_ARGON2ID');
  static const Crypt CRYPT_SHA256 =
      Crypt._(2, _omitEnumNames ? '' : 'CRYPT_SHA256');

  static const $core.List<Crypt> values = <Crypt>[
    CRYPT_UNSPECIFIED,
    CRYPT_ARGON2ID,
    CRYPT_SHA256,
  ];

  static final $core.List<Crypt?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Crypt? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Crypt._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
