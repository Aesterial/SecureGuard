// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/passwords/v1/domain.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ServiceInfo extends $pb.GeneratedMessage {
  factory ServiceInfo({
    $core.String? url,
    $core.String? name,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (name != null) result.name = name;
    return result;
  }

  ServiceInfo._();

  factory ServiceInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.passwords.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceInfo copyWith(void Function(ServiceInfo) updates) =>
      super.copyWith((message) => updates(message as ServiceInfo))
          as ServiceInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceInfo create() => ServiceInfo._();
  @$core.override
  ServiceInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceInfo>(create);
  static ServiceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);
}

class Password extends $pb.GeneratedMessage {
  factory Password({
    $core.String? id,
    ServiceInfo? serv,
    $core.String? login,
    $core.String? pass,
    $0.Timestamp? createdAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serv != null) result.serv = serv;
    if (login != null) result.login = login;
    if (pass != null) result.pass = pass;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Password._();

  factory Password.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Password.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Password',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.passwords.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<ServiceInfo>(2, _omitFieldNames ? '' : 'serv',
        subBuilder: ServiceInfo.create)
    ..aOS(3, _omitFieldNames ? '' : 'login')
    ..aOS(4, _omitFieldNames ? '' : 'pass')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Password clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Password copyWith(void Function(Password) updates) =>
      super.copyWith((message) => updates(message as Password)) as Password;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Password create() => Password._();
  @$core.override
  Password createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Password getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Password>(create);
  static Password? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  ServiceInfo get serv => $_getN(1);
  @$pb.TagNumber(2)
  set serv(ServiceInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasServ() => $_has(1);
  @$pb.TagNumber(2)
  void clearServ() => $_clearField(2);

  @$pb.TagNumber(2)
  ServiceInfo ensureServ() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get login => $_getSZ(2);
  @$pb.TagNumber(3)
  set login($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLogin() => $_has(2);
  @$pb.TagNumber(3)
  void clearLogin() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pass => $_getSZ(3);
  @$pb.TagNumber(4)
  set pass($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPass() => $_has(3);
  @$pb.TagNumber(4)
  void clearPass() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get createdAt => $_getN(4);

  @$pb.TagNumber(5)
  set createdAt($0.Timestamp value) => $_setField(5, value);

  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);

  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);

  @$pb.TagNumber(5)
  $0.Timestamp ensureCreatedAt() => $_ensure(4);
}

class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    $core.Iterable<Password>? list,
    $core.int? count,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    if (count != null) result.count = count;
    return result;
  }

  ListResponse._();

  factory ListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.passwords.v1'),
      createEmptyInstance: create)
    ..pPM<Password>(1, _omitFieldNames ? '' : 'list',
        subBuilder: Password.create)
    ..aI(2, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListResponse copyWith(void Function(ListResponse) updates) =>
      super.copyWith((message) => updates(message as ListResponse))
          as ListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListResponse create() => ListResponse._();
  @$core.override
  ListResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListResponse>(create);
  static ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Password> get list => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get count => $_getIZ(1);
  @$pb.TagNumber(2)
  set count($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCount() => $_clearField(2);
}

class CreateRequest extends $pb.GeneratedMessage {
  factory CreateRequest({
    $core.String? serviceUrl,
    $core.String? login,
    $core.String? ciphertext,
    $core.int? version,
    $core.String? nonce,
    $core.List<$core.int>? aad,
    $core.String? metadata,
  }) {
    final result = create();
    if (serviceUrl != null) result.serviceUrl = serviceUrl;
    if (login != null) result.login = login;
    if (ciphertext != null) result.ciphertext = ciphertext;
    if (version != null) result.version = version;
    if (nonce != null) result.nonce = nonce;
    if (aad != null) result.aad = aad;
    if (metadata != null) result.metadata = metadata;
    return result;
  }

  CreateRequest._();

  factory CreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.passwords.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceUrl')
    ..aOS(2, _omitFieldNames ? '' : 'login')
    ..aOS(3, _omitFieldNames ? '' : 'ciphertext')
    ..aI(4, _omitFieldNames ? '' : 'version')
    ..aOS(5, _omitFieldNames ? '' : 'nonce')
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'aad', $pb.PbFieldType.OY)
    ..aOS(7, _omitFieldNames ? '' : 'metadata')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRequest copyWith(void Function(CreateRequest) updates) =>
      super.copyWith((message) => updates(message as CreateRequest))
          as CreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRequest create() => CreateRequest._();
  @$core.override
  CreateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateRequest>(create);
  static CreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get login => $_getSZ(1);
  @$pb.TagNumber(2)
  set login($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLogin() => $_has(1);
  @$pb.TagNumber(2)
  void clearLogin() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get ciphertext => $_getSZ(2);
  @$pb.TagNumber(3)
  set ciphertext($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCiphertext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCiphertext() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get version => $_getIZ(3);
  @$pb.TagNumber(4)
  set version($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get nonce => $_getSZ(4);
  @$pb.TagNumber(5)
  set nonce($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNonce() => $_has(4);
  @$pb.TagNumber(5)
  void clearNonce() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get aad => $_getN(5);
  @$pb.TagNumber(6)
  set aad($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAad() => $_has(5);
  @$pb.TagNumber(6)
  void clearAad() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get metadata => $_getSZ(6);
  @$pb.TagNumber(7)
  set metadata($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMetadata() => $_has(6);
  @$pb.TagNumber(7)
  void clearMetadata() => $_clearField(7);
}

class PassDataResponse extends $pb.GeneratedMessage {
  factory PassDataResponse({
    Password? info,
    $0.Timestamp? at,
  }) {
    final result = create();
    if (info != null) result.info = info;
    if (at != null) result.at = at;
    return result;
  }

  PassDataResponse._();

  factory PassDataResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PassDataResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PassDataResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.passwords.v1'),
      createEmptyInstance: create)
    ..aOM<Password>(1, _omitFieldNames ? '' : 'info',
        subBuilder: Password.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PassDataResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PassDataResponse copyWith(void Function(PassDataResponse) updates) =>
      super.copyWith((message) => updates(message as PassDataResponse))
          as PassDataResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PassDataResponse create() => PassDataResponse._();
  @$core.override
  PassDataResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PassDataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PassDataResponse>(create);
  static PassDataResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Password get info => $_getN(0);
  @$pb.TagNumber(1)
  set info(Password value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  Password ensureInfo() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get at => $_getN(1);
  @$pb.TagNumber(2)
  set at($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureAt() => $_ensure(1);
}

class UpdateRequest extends $pb.GeneratedMessage {
  factory UpdateRequest({
    $core.String? id,
    $core.String? serviceUrl,
    $core.String? login,
    $core.String? pass,
    $core.String? salt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (serviceUrl != null) result.serviceUrl = serviceUrl;
    if (login != null) result.login = login;
    if (pass != null) result.pass = pass;
    if (salt != null) result.salt = salt;
    return result;
  }

  UpdateRequest._();

  factory UpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.passwords.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'serviceUrl')
    ..aOS(3, _omitFieldNames ? '' : 'login')
    ..aOS(4, _omitFieldNames ? '' : 'pass')
    ..aOS(5, _omitFieldNames ? '' : 'salt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRequest copyWith(void Function(UpdateRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateRequest))
          as UpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRequest create() => UpdateRequest._();
  @$core.override
  UpdateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateRequest>(create);
  static UpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get login => $_getSZ(2);
  @$pb.TagNumber(3)
  set login($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLogin() => $_has(2);
  @$pb.TagNumber(3)
  void clearLogin() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pass => $_getSZ(3);
  @$pb.TagNumber(4)
  set pass($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPass() => $_has(3);
  @$pb.TagNumber(4)
  void clearPass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get salt => $_getSZ(4);
  @$pb.TagNumber(5)
  set salt($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSalt() => $_has(4);
  @$pb.TagNumber(5)
  void clearSalt() => $_clearField(5);
}

class DeleteResponse extends $pb.GeneratedMessage {
  factory DeleteResponse() => create();

  DeleteResponse._();

  factory DeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.passwords.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteResponse copyWith(void Function(DeleteResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteResponse))
          as DeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteResponse create() => DeleteResponse._();
  @$core.override
  DeleteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteResponse>(create);
  static DeleteResponse? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
