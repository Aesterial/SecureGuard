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
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

import 'domain.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'domain.pbenum.dart';

class ServerInfo extends $pb.GeneratedMessage {
  factory ServerInfo({
    $core.String? name,
    $core.String? version,
    $core.String? runtimeVersion,
    $core.Iterable<$core.double>? supporingVer,
    $core.String? commitHash,
    $core.String? reporitory,
    $0.Timestamp? buildTime,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (version != null) result.version = version;
    if (runtimeVersion != null) result.runtimeVersion = runtimeVersion;
    if (supporingVer != null) result.supporingVer.addAll(supporingVer);
    if (commitHash != null) result.commitHash = commitHash;
    if (reporitory != null) result.reporitory = reporitory;
    if (buildTime != null) result.buildTime = buildTime;
    return result;
  }

  ServerInfo._();

  factory ServerInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.api.v1.meta.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'runtimeVersion')
    ..p<$core.double>(
        4, _omitFieldNames ? '' : 'supporingVer', $pb.PbFieldType.KF)
    ..aOS(5, _omitFieldNames ? '' : 'commitHash')
    ..aOS(6, _omitFieldNames ? '' : 'reporitory')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'buildTime',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerInfo copyWith(void Function(ServerInfo) updates) =>
      super.copyWith((message) => updates(message as ServerInfo)) as ServerInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerInfo create() => ServerInfo._();
  @$core.override
  ServerInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerInfo>(create);
  static ServerInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get runtimeVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set runtimeVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRuntimeVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearRuntimeVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.double> get supporingVer => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get commitHash => $_getSZ(4);
  @$pb.TagNumber(5)
  set commitHash($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCommitHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearCommitHash() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reporitory => $_getSZ(5);
  @$pb.TagNumber(6)
  set reporitory($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReporitory() => $_has(5);
  @$pb.TagNumber(6)
  void clearReporitory() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get buildTime => $_getN(6);
  @$pb.TagNumber(7)
  set buildTime($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBuildTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearBuildTime() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureBuildTime() => $_ensure(6);
}

class ServerInfoResponse extends $pb.GeneratedMessage {
  factory ServerInfoResponse({
    ServerInfo? info,
  }) {
    final result = create();
    if (info != null) result.info = info;
    return result;
  }

  ServerInfoResponse._();

  factory ServerInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServerInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServerInfoResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.api.v1.meta.v1'),
      createEmptyInstance: create)
    ..aOM<ServerInfo>(1, _omitFieldNames ? '' : 'info',
        subBuilder: ServerInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServerInfoResponse copyWith(void Function(ServerInfoResponse) updates) =>
      super.copyWith((message) => updates(message as ServerInfoResponse))
          as ServerInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServerInfoResponse create() => ServerInfoResponse._();
  @$core.override
  ServerInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServerInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServerInfoResponse>(create);
  static ServerInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServerInfo get info => $_getN(0);
  @$pb.TagNumber(1)
  set info(ServerInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearInfo() => $_clearField(1);
  @$pb.TagNumber(1)
  ServerInfo ensureInfo() => $_ensure(0);
}

class CompatibilityRequest extends $pb.GeneratedMessage {
  factory CompatibilityRequest({
    $core.double? clientApiVersion,
    ClientType? type,
  }) {
    final result = create();
    if (clientApiVersion != null) result.clientApiVersion = clientApiVersion;
    if (type != null) result.type = type;
    return result;
  }

  CompatibilityRequest._();

  factory CompatibilityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompatibilityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompatibilityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.api.v1.meta.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'clientApiVersion',
        fieldType: $pb.PbFieldType.OF)
    ..aE<ClientType>(2, _omitFieldNames ? '' : 'type',
        enumValues: ClientType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompatibilityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompatibilityRequest copyWith(void Function(CompatibilityRequest) updates) =>
      super.copyWith((message) => updates(message as CompatibilityRequest))
          as CompatibilityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompatibilityRequest create() => CompatibilityRequest._();
  @$core.override
  CompatibilityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompatibilityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompatibilityRequest>(create);
  static CompatibilityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get clientApiVersion => $_getN(0);
  @$pb.TagNumber(1)
  set clientApiVersion($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientApiVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientApiVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  ClientType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(ClientType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);
}

class CompatibilityResponse extends $pb.GeneratedMessage {
  factory CompatibilityResponse({
    $core.bool? value,
    $core.Iterable<$core.String>? reasons,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (reasons != null) result.reasons.addAll(reasons);
    return result;
  }

  CompatibilityResponse._();

  factory CompatibilityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompatibilityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompatibilityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.api.v1.meta.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..pPS(2, _omitFieldNames ? '' : 'reasons')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompatibilityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompatibilityResponse copyWith(
          void Function(CompatibilityResponse) updates) =>
      super.copyWith((message) => updates(message as CompatibilityResponse))
          as CompatibilityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompatibilityResponse create() => CompatibilityResponse._();
  @$core.override
  CompatibilityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompatibilityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompatibilityResponse>(create);
  static CompatibilityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get reasons => $_getList(1);
}

class LocalisationResponse extends $pb.GeneratedMessage {
  factory LocalisationResponse({
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? ru,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? en,
  }) {
    final result = create();
    if (ru != null) result.ru.addEntries(ru);
    if (en != null) result.en.addEntries(en);
    return result;
  }

  LocalisationResponse._();

  factory LocalisationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);

  factory LocalisationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LocalisationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.api.v1.meta.v1'),
      createEmptyInstance: create)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'ru',
        entryClassName: 'LocalisationResponse.RuEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('xyz.secureguard.api.v1.meta.v1'))
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'en',
        entryClassName: 'LocalisationResponse.EnEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('xyz.secureguard.api.v1.meta.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocalisationResponse clone() => deepCopy();

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocalisationResponse copyWith(void Function(LocalisationResponse) updates) =>
      super.copyWith((message) => updates(message as LocalisationResponse))
          as LocalisationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LocalisationResponse create() => LocalisationResponse._();

  @$core.override
  LocalisationResponse createEmptyInstance() => create();

  @$core.pragma('dart2js:noInline')
  static LocalisationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LocalisationResponse>(create);
  static LocalisationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.String> get ru => $_getMap(0);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get en => $_getMap(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
