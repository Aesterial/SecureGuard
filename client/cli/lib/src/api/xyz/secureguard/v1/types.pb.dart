// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/types.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class RequestWithID extends $pb.GeneratedMessage {
  factory RequestWithID({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  RequestWithID._();

  factory RequestWithID.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWithID.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWithID',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithID clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithID copyWith(void Function(RequestWithID) updates) =>
      super.copyWith((message) => updates(message as RequestWithID))
          as RequestWithID;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWithID create() => RequestWithID._();
  @$core.override
  RequestWithID createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWithID getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWithID>(create);
  static RequestWithID? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class RequestWithIdAndValue extends $pb.GeneratedMessage {
  factory RequestWithIdAndValue({
    $core.String? id,
    $core.String? value,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (value != null) result.value = value;
    return result;
  }

  RequestWithIdAndValue._();

  factory RequestWithIdAndValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWithIdAndValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWithIdAndValue',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithIdAndValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithIdAndValue copyWith(
          void Function(RequestWithIdAndValue) updates) =>
      super.copyWith((message) => updates(message as RequestWithIdAndValue))
          as RequestWithIdAndValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWithIdAndValue create() => RequestWithIdAndValue._();
  @$core.override
  RequestWithIdAndValue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWithIdAndValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWithIdAndValue>(create);
  static RequestWithIdAndValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class RequestWithValue extends $pb.GeneratedMessage {
  factory RequestWithValue({
    $core.String? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  RequestWithValue._();

  factory RequestWithValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWithValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWithValue',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithValue copyWith(void Function(RequestWithValue) updates) =>
      super.copyWith((message) => updates(message as RequestWithValue))
          as RequestWithValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWithValue create() => RequestWithValue._();
  @$core.override
  RequestWithValue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWithValue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWithValue>(create);
  static RequestWithValue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get value => $_getSZ(0);
  @$pb.TagNumber(1)
  set value($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class RequestWithLimit extends $pb.GeneratedMessage {
  factory RequestWithLimit({
    $core.int? limit,
  }) {
    final result = create();
    if (limit != null) result.limit = limit;
    return result;
  }

  RequestWithLimit._();

  factory RequestWithLimit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWithLimit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWithLimit',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithLimit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithLimit copyWith(void Function(RequestWithLimit) updates) =>
      super.copyWith((message) => updates(message as RequestWithLimit))
          as RequestWithLimit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWithLimit create() => RequestWithLimit._();
  @$core.override
  RequestWithLimit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWithLimit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWithLimit>(create);
  static RequestWithLimit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);
}

class RequestWithOffset extends $pb.GeneratedMessage {
  factory RequestWithOffset({
    $core.int? offset,
  }) {
    final result = create();
    if (offset != null) result.offset = offset;
    return result;
  }

  RequestWithOffset._();

  factory RequestWithOffset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWithOffset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWithOffset',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithOffset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithOffset copyWith(void Function(RequestWithOffset) updates) =>
      super.copyWith((message) => updates(message as RequestWithOffset))
          as RequestWithOffset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWithOffset create() => RequestWithOffset._();
  @$core.override
  RequestWithOffset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWithOffset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWithOffset>(create);
  static RequestWithOffset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get offset => $_getIZ(0);
  @$pb.TagNumber(1)
  set offset($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffset() => $_clearField(1);
}

class RequestWithLimitAndOffset extends $pb.GeneratedMessage {
  factory RequestWithLimitAndOffset({
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  RequestWithLimitAndOffset._();

  factory RequestWithLimitAndOffset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWithLimitAndOffset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWithLimitAndOffset',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'limit')
    ..aI(2, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithLimitAndOffset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithLimitAndOffset copyWith(
          void Function(RequestWithLimitAndOffset) updates) =>
      super.copyWith((message) => updates(message as RequestWithLimitAndOffset))
          as RequestWithLimitAndOffset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWithLimitAndOffset create() => RequestWithLimitAndOffset._();
  @$core.override
  RequestWithLimitAndOffset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWithLimitAndOffset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWithLimitAndOffset>(create);
  static RequestWithLimitAndOffset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get limit => $_getIZ(0);
  @$pb.TagNumber(1)
  set limit($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLimit() => $_has(0);
  @$pb.TagNumber(1)
  void clearLimit() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get offset => $_getIZ(1);
  @$pb.TagNumber(2)
  set offset($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);
}

class RequestWithBoolean extends $pb.GeneratedMessage {
  factory RequestWithBoolean({
    $core.bool? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  RequestWithBoolean._();

  factory RequestWithBoolean.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWithBoolean.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWithBoolean',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithBoolean clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithBoolean copyWith(void Function(RequestWithBoolean) updates) =>
      super.copyWith((message) => updates(message as RequestWithBoolean))
          as RequestWithBoolean;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWithBoolean create() => RequestWithBoolean._();
  @$core.override
  RequestWithBoolean createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWithBoolean getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWithBoolean>(create);
  static RequestWithBoolean? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class RequestWithBooleanLimitOffset extends $pb.GeneratedMessage {
  factory RequestWithBooleanLimitOffset({
    $core.bool? value,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  RequestWithBooleanLimitOffset._();

  factory RequestWithBooleanLimitOffset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWithBooleanLimitOffset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWithBooleanLimitOffset',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'value')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..aI(3, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithBooleanLimitOffset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithBooleanLimitOffset copyWith(
          void Function(RequestWithBooleanLimitOffset) updates) =>
      super.copyWith(
              (message) => updates(message as RequestWithBooleanLimitOffset))
          as RequestWithBooleanLimitOffset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWithBooleanLimitOffset create() =>
      RequestWithBooleanLimitOffset._();
  @$core.override
  RequestWithBooleanLimitOffset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWithBooleanLimitOffset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWithBooleanLimitOffset>(create);
  static RequestWithBooleanLimitOffset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get offset => $_getIZ(2);
  @$pb.TagNumber(3)
  set offset($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);
}

class Kdf extends $pb.GeneratedMessage {
  factory Kdf({
    $core.int? version,
    $fixnum.Int64? memory,
    $core.int? iterations,
    $core.int? parallelism,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (memory != null) result.memory = memory;
    if (iterations != null) result.iterations = iterations;
    if (parallelism != null) result.parallelism = parallelism;
    return result;
  }

  Kdf._();

  factory Kdf.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Kdf.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Kdf',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'version')
    ..aInt64(2, _omitFieldNames ? '' : 'memory')
    ..aI(3, _omitFieldNames ? '' : 'iterations')
    ..aI(4, _omitFieldNames ? '' : 'parallelism')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Kdf clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Kdf copyWith(void Function(Kdf) updates) =>
      super.copyWith((message) => updates(message as Kdf)) as Kdf;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Kdf create() => Kdf._();
  @$core.override
  Kdf createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Kdf getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Kdf>(create);
  static Kdf? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get memory => $_getI64(1);
  @$pb.TagNumber(2)
  set memory($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMemory() => $_has(1);
  @$pb.TagNumber(2)
  void clearMemory() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get iterations => $_getIZ(2);
  @$pb.TagNumber(3)
  set iterations($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIterations() => $_has(2);
  @$pb.TagNumber(3)
  void clearIterations() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get parallelism => $_getIZ(3);
  @$pb.TagNumber(4)
  set parallelism($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParallelism() => $_has(3);
  @$pb.TagNumber(4)
  void clearParallelism() => $_clearField(4);
}

class RequestWithValueAndKdf extends $pb.GeneratedMessage {
  factory RequestWithValueAndKdf({
    Kdf? kdf,
    $core.String? value,
    $core.String? salt,
  }) {
    final result = create();
    if (kdf != null) result.kdf = kdf;
    if (value != null) result.value = value;
    if (salt != null) result.salt = salt;
    return result;
  }

  RequestWithValueAndKdf._();

  factory RequestWithValueAndKdf.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequestWithValueAndKdf.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestWithValueAndKdf',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'xyz.secureguard.v1'),
      createEmptyInstance: create)
    ..aOM<Kdf>(1, _omitFieldNames ? '' : 'kdf', subBuilder: Kdf.create)
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..aOS(3, _omitFieldNames ? '' : 'salt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithValueAndKdf clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestWithValueAndKdf copyWith(
          void Function(RequestWithValueAndKdf) updates) =>
      super.copyWith((message) => updates(message as RequestWithValueAndKdf))
          as RequestWithValueAndKdf;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequestWithValueAndKdf create() => RequestWithValueAndKdf._();
  @$core.override
  RequestWithValueAndKdf createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequestWithValueAndKdf getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestWithValueAndKdf>(create);
  static RequestWithValueAndKdf? _defaultInstance;

  @$pb.TagNumber(1)
  Kdf get kdf => $_getN(0);
  @$pb.TagNumber(1)
  set kdf(Kdf value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKdf() => $_has(0);
  @$pb.TagNumber(1)
  void clearKdf() => $_clearField(1);
  @$pb.TagNumber(1)
  Kdf ensureKdf() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get salt => $_getSZ(2);

  @$pb.TagNumber(3)
  set salt($core.String value) => $_setString(2, value);

  @$pb.TagNumber(3)
  $core.bool hasSalt() => $_has(2);

  @$pb.TagNumber(3)
  void clearSalt() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
