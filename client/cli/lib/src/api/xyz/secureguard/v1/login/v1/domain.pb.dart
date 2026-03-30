// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/login/v1/domain.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../types.pb.dart' as $0;
import '../../users/v1/domain.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class AuthorizeRequest extends $pb.GeneratedMessage {
  factory AuthorizeRequest({
    $core.String? username,
    $core.String? password,
    $core.String? masterKey,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    if (masterKey != null) result.masterKey = masterKey;
    return result;
  }

  AuthorizeRequest._();

  factory AuthorizeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthorizeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthorizeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.login.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'masterKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthorizeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthorizeRequest copyWith(void Function(AuthorizeRequest) updates) =>
      super.copyWith((message) => updates(message as AuthorizeRequest))
          as AuthorizeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthorizeRequest create() => AuthorizeRequest._();
  @$core.override
  AuthorizeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthorizeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthorizeRequest>(create);
  static AuthorizeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get masterKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set masterKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMasterKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearMasterKey() => $_clearField(3);
}

class RegisterRequest extends $pb.GeneratedMessage {
  factory RegisterRequest({
    $core.String? username,
    $core.String? password,
    $core.String? masterKey,
    $core.String? salt,
    $0.Kdf? kdfParams,
  }) {
    final result = create();
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    if (masterKey != null) result.masterKey = masterKey;
    if (salt != null) result.salt = salt;
    if (kdfParams != null) result.kdfParams = kdfParams;
    return result;
  }

  RegisterRequest._();

  factory RegisterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.login.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'masterKey')
    ..aOS(4, _omitFieldNames ? '' : 'salt')
    ..aOM<$0.Kdf>(5, _omitFieldNames ? '' : 'kdfParams',
        subBuilder: $0.Kdf.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterRequest copyWith(void Function(RegisterRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterRequest))
          as RegisterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterRequest create() => RegisterRequest._();
  @$core.override
  RegisterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterRequest>(create);
  static RegisterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get masterKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set masterKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMasterKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearMasterKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get salt => $_getSZ(3);
  @$pb.TagNumber(4)
  set salt($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSalt() => $_has(3);
  @$pb.TagNumber(4)
  void clearSalt() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Kdf get kdfParams => $_getN(4);
  @$pb.TagNumber(5)
  set kdfParams($0.Kdf value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKdfParams() => $_has(4);
  @$pb.TagNumber(5)
  void clearKdfParams() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Kdf ensureKdfParams() => $_ensure(4);
}

class LoginResponse extends $pb.GeneratedMessage {
  factory LoginResponse({
    $1.UserSelf? info,
    $core.String? session,
  }) {
    final result = create();
    if (info != null) result.info = info;
    if (session != null) result.session = session;
    return result;
  }

  LoginResponse._();

  factory LoginResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoginResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoginResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.login.v1'),
      createEmptyInstance: create)
    ..aOM<$1.UserSelf>(1, _omitFieldNames ? '' : 'info',
        subBuilder: $1.UserSelf.create)
    ..aOS(2, _omitFieldNames ? '' : 'session')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoginResponse copyWith(void Function(LoginResponse) updates) =>
      super.copyWith((message) => updates(message as LoginResponse))
          as LoginResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginResponse create() => LoginResponse._();
  @$core.override
  LoginResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoginResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoginResponse>(create);
  static LoginResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UserSelf get info => $_getN(0);
  @$pb.TagNumber(1)
  set info($1.UserSelf value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UserSelf ensureInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get session => $_getSZ(1);
  @$pb.TagNumber(2)
  set session($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSession() => $_has(1);
  @$pb.TagNumber(2)
  void clearSession() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
