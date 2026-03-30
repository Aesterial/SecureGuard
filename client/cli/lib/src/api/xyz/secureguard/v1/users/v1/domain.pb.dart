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
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart' as $1;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

import 'domain.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'domain.pbenum.dart';

class Preferences extends $pb.GeneratedMessage {
  factory Preferences({
    Theme? theme,
    Language? lang,
    Crypt? crypto,
  }) {
    final result = create();
    if (theme != null) result.theme = theme;
    if (lang != null) result.lang = lang;
    if (crypto != null) result.crypto = crypto;
    return result;
  }

  Preferences._();

  factory Preferences.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Preferences.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Preferences',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aE<Theme>(1, _omitFieldNames ? '' : 'theme', enumValues: Theme.values)
    ..aE<Language>(2, _omitFieldNames ? '' : 'lang',
        enumValues: Language.values)
    ..aE<Crypt>(3, _omitFieldNames ? '' : 'crypto', enumValues: Crypt.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Preferences clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Preferences copyWith(void Function(Preferences) updates) =>
      super.copyWith((message) => updates(message as Preferences))
          as Preferences;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Preferences create() => Preferences._();
  @$core.override
  Preferences createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Preferences getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Preferences>(create);
  static Preferences? _defaultInstance;

  @$pb.TagNumber(1)
  Theme get theme => $_getN(0);
  @$pb.TagNumber(1)
  set theme(Theme value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTheme() => $_has(0);
  @$pb.TagNumber(1)
  void clearTheme() => $_clearField(1);

  @$pb.TagNumber(2)
  Language get lang => $_getN(1);
  @$pb.TagNumber(2)
  set lang(Language value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLang() => $_has(1);
  @$pb.TagNumber(2)
  void clearLang() => $_clearField(2);

  @$pb.TagNumber(3)
  Crypt get crypto => $_getN(2);
  @$pb.TagNumber(3)
  set crypto(Crypt value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCrypto() => $_has(2);
  @$pb.TagNumber(3)
  void clearCrypto() => $_clearField(3);
}

class UserSelf extends $pb.GeneratedMessage {
  factory UserSelf({
    $core.String? id,
    $core.String? username,
    $0.Timestamp? joined,
    $core.bool? staff,
    $core.String? phrase,
    Preferences? preferences,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (username != null) result.username = username;
    if (joined != null) result.joined = joined;
    if (staff != null) result.staff = staff;
    if (phrase != null) result.phrase = phrase;
    if (preferences != null) result.preferences = preferences;
    return result;
  }

  UserSelf._();

  factory UserSelf.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserSelf.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserSelf',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'joined',
        subBuilder: $0.Timestamp.create)
    ..aOB(4, _omitFieldNames ? '' : 'staff')
    ..aOS(5, _omitFieldNames ? '' : 'phrase')
    ..aOM<Preferences>(6, _omitFieldNames ? '' : 'preferences',
        subBuilder: Preferences.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSelf clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSelf copyWith(void Function(UserSelf) updates) =>
      super.copyWith((message) => updates(message as UserSelf)) as UserSelf;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserSelf create() => UserSelf._();
  @$core.override
  UserSelf createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserSelf getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserSelf>(create);
  static UserSelf? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get joined => $_getN(2);
  @$pb.TagNumber(3)
  set joined($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasJoined() => $_has(2);
  @$pb.TagNumber(3)
  void clearJoined() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureJoined() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get staff => $_getBF(3);
  @$pb.TagNumber(4)
  set staff($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStaff() => $_has(3);
  @$pb.TagNumber(4)
  void clearStaff() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get phrase => $_getSZ(4);
  @$pb.TagNumber(5)
  set phrase($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPhrase() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhrase() => $_clearField(5);

  @$pb.TagNumber(6)
  Preferences get preferences => $_getN(5);
  @$pb.TagNumber(6)
  set preferences(Preferences value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPreferences() => $_has(5);
  @$pb.TagNumber(6)
  void clearPreferences() => $_clearField(6);
  @$pb.TagNumber(6)
  Preferences ensurePreferences() => $_ensure(5);
}

class UserPublic extends $pb.GeneratedMessage {
  factory UserPublic({
    $core.String? id,
    $core.String? username,
    Language? lang,
    Crypt? crypt,
    $core.bool? phraseSet,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (username != null) result.username = username;
    if (lang != null) result.lang = lang;
    if (crypt != null) result.crypt = crypt;
    if (phraseSet != null) result.phraseSet = phraseSet;
    return result;
  }

  UserPublic._();

  factory UserPublic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserPublic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserPublic',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'username')
    ..aE<Language>(3, _omitFieldNames ? '' : 'lang',
        enumValues: Language.values)
    ..aE<Crypt>(4, _omitFieldNames ? '' : 'crypt', enumValues: Crypt.values)
    ..aOB(5, _omitFieldNames ? '' : 'phraseSet')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPublic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserPublic copyWith(void Function(UserPublic) updates) =>
      super.copyWith((message) => updates(message as UserPublic)) as UserPublic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserPublic create() => UserPublic._();
  @$core.override
  UserPublic createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserPublic getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserPublic>(create);
  static UserPublic? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => $_clearField(2);

  @$pb.TagNumber(3)
  Language get lang => $_getN(2);
  @$pb.TagNumber(3)
  set lang(Language value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLang() => $_has(2);
  @$pb.TagNumber(3)
  void clearLang() => $_clearField(3);

  @$pb.TagNumber(4)
  Crypt get crypt => $_getN(3);
  @$pb.TagNumber(4)
  set crypt(Crypt value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCrypt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCrypt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get phraseSet => $_getBF(4);
  @$pb.TagNumber(5)
  set phraseSet($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPhraseSet() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhraseSet() => $_clearField(5);
}

class UserResponse extends $pb.GeneratedMessage {
  factory UserResponse({
    UserSelf? info,
  }) {
    final result = create();
    if (info != null) result.info = info;
    return result;
  }

  UserResponse._();

  factory UserResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aOM<UserSelf>(1, _omitFieldNames ? '' : 'info',
        subBuilder: UserSelf.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserResponse copyWith(void Function(UserResponse) updates) =>
      super.copyWith((message) => updates(message as UserResponse))
          as UserResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserResponse create() => UserResponse._();
  @$core.override
  UserResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserResponse>(create);
  static UserResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UserSelf get info => $_getN(0);
  @$pb.TagNumber(1)
  set info(UserSelf value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  UserSelf ensureInfo() => $_ensure(0);
}

class ChangeThemeRequest extends $pb.GeneratedMessage {
  factory ChangeThemeRequest({
    Theme? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  ChangeThemeRequest._();

  factory ChangeThemeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeThemeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeThemeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aE<Theme>(1, _omitFieldNames ? '' : 'value', enumValues: Theme.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeThemeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeThemeRequest copyWith(void Function(ChangeThemeRequest) updates) =>
      super.copyWith((message) => updates(message as ChangeThemeRequest))
          as ChangeThemeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeThemeRequest create() => ChangeThemeRequest._();
  @$core.override
  ChangeThemeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeThemeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeThemeRequest>(create);
  static ChangeThemeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Theme get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(Theme value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class ChangeLanguageRequest extends $pb.GeneratedMessage {
  factory ChangeLanguageRequest({
    Language? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  ChangeLanguageRequest._();

  factory ChangeLanguageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeLanguageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeLanguageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aE<Language>(1, _omitFieldNames ? '' : 'value',
        enumValues: Language.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeLanguageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeLanguageRequest copyWith(
          void Function(ChangeLanguageRequest) updates) =>
      super.copyWith((message) => updates(message as ChangeLanguageRequest))
          as ChangeLanguageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeLanguageRequest create() => ChangeLanguageRequest._();
  @$core.override
  ChangeLanguageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeLanguageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeLanguageRequest>(create);
  static ChangeLanguageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Language get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(Language value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class ChangeCryptRequest extends $pb.GeneratedMessage {
  factory ChangeCryptRequest({
    Crypt? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  ChangeCryptRequest._();

  factory ChangeCryptRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeCryptRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeCryptRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aE<Crypt>(1, _omitFieldNames ? '' : 'value', enumValues: Crypt.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeCryptRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeCryptRequest copyWith(void Function(ChangeCryptRequest) updates) =>
      super.copyWith((message) => updates(message as ChangeCryptRequest))
          as ChangeCryptRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeCryptRequest create() => ChangeCryptRequest._();
  @$core.override
  ChangeCryptRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeCryptRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeCryptRequest>(create);
  static ChangeCryptRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Crypt get value => $_getN(0);
  @$pb.TagNumber(1)
  set value(Crypt value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class ChangeThemeResponse extends $pb.GeneratedMessage {
  factory ChangeThemeResponse({
    Theme? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  ChangeThemeResponse._();

  factory ChangeThemeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeThemeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeThemeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aE<Theme>(1, _omitFieldNames ? '' : 'result', enumValues: Theme.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeThemeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeThemeResponse copyWith(void Function(ChangeThemeResponse) updates) =>
      super.copyWith((message) => updates(message as ChangeThemeResponse))
          as ChangeThemeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeThemeResponse create() => ChangeThemeResponse._();
  @$core.override
  ChangeThemeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeThemeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeThemeResponse>(create);
  static ChangeThemeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Theme get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(Theme value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
}

class ChangeLanguageResponse extends $pb.GeneratedMessage {
  factory ChangeLanguageResponse({
    Language? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  ChangeLanguageResponse._();

  factory ChangeLanguageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeLanguageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeLanguageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aE<Language>(1, _omitFieldNames ? '' : 'result',
        enumValues: Language.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeLanguageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeLanguageResponse copyWith(
          void Function(ChangeLanguageResponse) updates) =>
      super.copyWith((message) => updates(message as ChangeLanguageResponse))
          as ChangeLanguageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeLanguageResponse create() => ChangeLanguageResponse._();
  @$core.override
  ChangeLanguageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeLanguageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeLanguageResponse>(create);
  static ChangeLanguageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Language get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(Language value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
}

class ChangeCryptResponse extends $pb.GeneratedMessage {
  factory ChangeCryptResponse({
    Crypt? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  ChangeCryptResponse._();

  factory ChangeCryptResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeCryptResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeCryptResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aE<Crypt>(1, _omitFieldNames ? '' : 'result', enumValues: Crypt.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeCryptResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeCryptResponse copyWith(void Function(ChangeCryptResponse) updates) =>
      super.copyWith((message) => updates(message as ChangeCryptResponse))
          as ChangeCryptResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeCryptResponse create() => ChangeCryptResponse._();
  @$core.override
  ChangeCryptResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeCryptResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeCryptResponse>(create);
  static ChangeCryptResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Crypt get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(Crypt value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
}

class ValueChangeResponse extends $pb.GeneratedMessage {
  factory ValueChangeResponse({
    $1.Any? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  ValueChangeResponse._();

  factory ValueChangeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ValueChangeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValueChangeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.users.v1'),
      createEmptyInstance: create)
    ..aOM<$1.Any>(1, _omitFieldNames ? '' : 'result', subBuilder: $1.Any.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValueChangeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValueChangeResponse copyWith(void Function(ValueChangeResponse) updates) =>
      super.copyWith((message) => updates(message as ValueChangeResponse))
          as ValueChangeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValueChangeResponse create() => ValueChangeResponse._();
  @$core.override
  ValueChangeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ValueChangeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValueChangeResponse>(create);
  static ValueChangeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Any get result => $_getN(0);
  @$pb.TagNumber(1)
  set result($1.Any value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Any ensureResult() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
