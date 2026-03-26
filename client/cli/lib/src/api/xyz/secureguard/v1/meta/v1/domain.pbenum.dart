// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/meta/v1/domain.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ClientType extends $pb.ProtobufEnum {
  static const ClientType CLIENT_TYPE_SECUREGUARD_UNSPECIFIED = ClientType._(
      0, _omitEnumNames ? '' : 'CLIENT_TYPE_SECUREGUARD_UNSPECIFIED');
  static const ClientType CLIENT_TYPE_SECUREGUARD_WINDOWS =
      ClientType._(1, _omitEnumNames ? '' : 'CLIENT_TYPE_SECUREGUARD_WINDOWS');
  static const ClientType CLIENT_TYPE_SECUREGUARD_MAC =
      ClientType._(2, _omitEnumNames ? '' : 'CLIENT_TYPE_SECUREGUARD_MAC');
  static const ClientType CLIENT_TYPE_SECUREGUARD_LINUX =
      ClientType._(3, _omitEnumNames ? '' : 'CLIENT_TYPE_SECUREGUARD_LINUX');
  static const ClientType CLIENT_TYPE_SECUREGUARD_ANDROID =
      ClientType._(4, _omitEnumNames ? '' : 'CLIENT_TYPE_SECUREGUARD_ANDROID');
  static const ClientType CLIENT_TYPE_SECUREGUARD_IOS =
      ClientType._(5, _omitEnumNames ? '' : 'CLIENT_TYPE_SECUREGUARD_IOS');

  static const $core.List<ClientType> values = <ClientType>[
    CLIENT_TYPE_SECUREGUARD_UNSPECIFIED,
    CLIENT_TYPE_SECUREGUARD_WINDOWS,
    CLIENT_TYPE_SECUREGUARD_MAC,
    CLIENT_TYPE_SECUREGUARD_LINUX,
    CLIENT_TYPE_SECUREGUARD_ANDROID,
    CLIENT_TYPE_SECUREGUARD_IOS,
  ];

  static final $core.List<ClientType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ClientType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ClientType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
