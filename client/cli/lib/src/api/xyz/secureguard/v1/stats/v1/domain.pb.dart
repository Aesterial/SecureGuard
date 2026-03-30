// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/stats/v1/domain.proto.

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

class ByDateRequest extends $pb.GeneratedMessage {
  factory ByDateRequest({
    $0.Timestamp? day,
  }) {
    final result = create();
    if (day != null) result.day = day;
    return result;
  }

  ByDateRequest._();

  factory ByDateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ByDateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ByDateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.stats.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'day',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ByDateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ByDateRequest copyWith(void Function(ByDateRequest) updates) =>
      super.copyWith((message) => updates(message as ByDateRequest))
          as ByDateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ByDateRequest create() => ByDateRequest._();
  @$core.override
  ByDateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ByDateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ByDateRequest>(create);
  static ByDateRequest? _defaultInstance;

  @$pb.TagNumber(2)
  $0.Timestamp get day => $_getN(0);
  @$pb.TagNumber(2)
  set day($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDay() => $_has(0);
  @$pb.TagNumber(2)
  void clearDay() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureDay() => $_ensure(0);
}

class TotalResponse extends $pb.GeneratedMessage {
  factory TotalResponse({
    $core.int? users,
    $core.int? admins,
    $core.int? passwords,
    $core.int? activeSessions,
  }) {
    final result = create();
    if (users != null) result.users = users;
    if (admins != null) result.admins = admins;
    if (passwords != null) result.passwords = passwords;
    if (activeSessions != null) result.activeSessions = activeSessions;
    return result;
  }

  TotalResponse._();

  factory TotalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TotalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TotalResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.stats.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'users')
    ..aI(2, _omitFieldNames ? '' : 'admins')
    ..aI(3, _omitFieldNames ? '' : 'passwords')
    ..aI(4, _omitFieldNames ? '' : 'activeSessions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TotalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TotalResponse copyWith(void Function(TotalResponse) updates) =>
      super.copyWith((message) => updates(message as TotalResponse))
          as TotalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TotalResponse create() => TotalResponse._();
  @$core.override
  TotalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TotalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TotalResponse>(create);
  static TotalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get users => $_getIZ(0);
  @$pb.TagNumber(1)
  set users($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsers() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsers() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get admins => $_getIZ(1);
  @$pb.TagNumber(2)
  set admins($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAdmins() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdmins() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get passwords => $_getIZ(2);
  @$pb.TagNumber(3)
  set passwords($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPasswords() => $_has(2);
  @$pb.TagNumber(3)
  void clearPasswords() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get activeSessions => $_getIZ(3);
  @$pb.TagNumber(4)
  set activeSessions($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActiveSessions() => $_has(3);
  @$pb.TagNumber(4)
  void clearActiveSessions() => $_clearField(4);
}

class GraphPoint extends $pb.GeneratedMessage {
  factory GraphPoint({
    $0.Timestamp? time,
    $core.int? value,
  }) {
    final result = create();
    if (time != null) result.time = time;
    if (value != null) result.value = value;
    return result;
  }

  GraphPoint._();

  factory GraphPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GraphPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GraphPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.stats.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'time',
        subBuilder: $0.Timestamp.create)
    ..aI(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GraphPoint copyWith(void Function(GraphPoint) updates) =>
      super.copyWith((message) => updates(message as GraphPoint)) as GraphPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GraphPoint create() => GraphPoint._();
  @$core.override
  GraphPoint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GraphPoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GraphPoint>(create);
  static GraphPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get time => $_getN(0);
  @$pb.TagNumber(1)
  set time($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureTime() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get value => $_getIZ(1);
  @$pb.TagNumber(2)
  set value($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class Latency extends $pb.GeneratedMessage {
  factory Latency({
    $core.double? p50,
    $core.double? p90,
  }) {
    final result = create();
    if (p50 != null) result.p50 = p50;
    if (p90 != null) result.p90 = p90;
    return result;
  }

  Latency._();

  factory Latency.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Latency.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Latency',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.stats.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'p50')
    ..aD(2, _omitFieldNames ? '' : 'p90')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Latency clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Latency copyWith(void Function(Latency) updates) =>
      super.copyWith((message) => updates(message as Latency)) as Latency;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Latency create() => Latency._();
  @$core.override
  Latency createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Latency getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Latency>(create);
  static Latency? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get p50 => $_getN(0);
  @$pb.TagNumber(1)
  set p50($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasP50() => $_has(0);
  @$pb.TagNumber(1)
  void clearP50() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get p90 => $_getN(1);
  @$pb.TagNumber(2)
  set p90($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasP90() => $_has(1);
  @$pb.TagNumber(2)
  void clearP90() => $_clearField(2);
}

class Stats extends $pb.GeneratedMessage {
  factory Stats({
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? topServices,
    $core.Iterable<GraphPoint>? registerGraph,
    $core.Iterable<GraphPoint>? usersGraph,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? cryptUses,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? themeUses,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? langUses,
    Latency? latency,
  }) {
    final result = create();
    if (topServices != null) result.topServices.addEntries(topServices);
    if (registerGraph != null) result.registerGraph.addAll(registerGraph);
    if (usersGraph != null) result.usersGraph.addAll(usersGraph);
    if (cryptUses != null) result.cryptUses.addEntries(cryptUses);
    if (themeUses != null) result.themeUses.addEntries(themeUses);
    if (langUses != null) result.langUses.addEntries(langUses);
    if (latency != null) result.latency = latency;
    return result;
  }

  Stats._();

  factory Stats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Stats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Stats',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.stats.v1'),
      createEmptyInstance: create)
    ..m<$core.String, $core.int>(1, _omitFieldNames ? '' : 'topServices',
        entryClassName: 'Stats.TopServicesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('xyz.secureguard.v1.stats.v1'))
    ..pPM<GraphPoint>(2, _omitFieldNames ? '' : 'registerGraph',
        subBuilder: GraphPoint.create)
    ..pPM<GraphPoint>(3, _omitFieldNames ? '' : 'usersGraph',
        subBuilder: GraphPoint.create)
    ..m<$core.String, $core.int>(4, _omitFieldNames ? '' : 'cryptUses',
        entryClassName: 'Stats.CryptUsesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('xyz.secureguard.v1.stats.v1'))
    ..m<$core.String, $core.int>(5, _omitFieldNames ? '' : 'themeUses',
        entryClassName: 'Stats.ThemeUsesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('xyz.secureguard.v1.stats.v1'))
    ..m<$core.String, $core.int>(6, _omitFieldNames ? '' : 'langUses',
        entryClassName: 'Stats.LangUsesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('xyz.secureguard.v1.stats.v1'))
    ..aOM<Latency>(7, _omitFieldNames ? '' : 'latency',
        subBuilder: Latency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Stats copyWith(void Function(Stats) updates) =>
      super.copyWith((message) => updates(message as Stats)) as Stats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Stats create() => Stats._();
  @$core.override
  Stats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Stats getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Stats>(create);
  static Stats? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, $core.int> get topServices => $_getMap(0);

  @$pb.TagNumber(2)
  $pb.PbList<GraphPoint> get registerGraph => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<GraphPoint> get usersGraph => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.int> get cryptUses => $_getMap(3);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.int> get themeUses => $_getMap(4);

  @$pb.TagNumber(6)
  $pb.PbMap<$core.String, $core.int> get langUses => $_getMap(5);

  @$pb.TagNumber(7)
  Latency get latency => $_getN(6);
  @$pb.TagNumber(7)
  set latency(Latency value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLatency() => $_has(6);
  @$pb.TagNumber(7)
  void clearLatency() => $_clearField(7);
  @$pb.TagNumber(7)
  Latency ensureLatency() => $_ensure(6);
}

class StatsResponse extends $pb.GeneratedMessage {
  factory StatsResponse({
    Stats? stats,
  }) {
    final result = create();
    if (stats != null) result.stats = stats;
    return result;
  }

  StatsResponse._();

  factory StatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.stats.v1'),
      createEmptyInstance: create)
    ..aOM<Stats>(1, _omitFieldNames ? '' : 'stats', subBuilder: Stats.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatsResponse copyWith(void Function(StatsResponse) updates) =>
      super.copyWith((message) => updates(message as StatsResponse))
          as StatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatsResponse create() => StatsResponse._();
  @$core.override
  StatsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatsResponse>(create);
  static StatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Stats get stats => $_getN(0);
  @$pb.TagNumber(1)
  set stats(Stats value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStats() => $_has(0);
  @$pb.TagNumber(1)
  void clearStats() => $_clearField(1);
  @$pb.TagNumber(1)
  Stats ensureStats() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
