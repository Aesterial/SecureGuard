// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/sessions/v1/domain.proto.

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

class Session_RevokeInfo extends $pb.GeneratedMessage {
  factory Session_RevokeInfo({
    $core.bool? revoked,
    $0.Timestamp? revokedAt,
  }) {
    final result = create();
    if (revoked != null) result.revoked = revoked;
    if (revokedAt != null) result.revokedAt = revokedAt;
    return result;
  }

  Session_RevokeInfo._();

  factory Session_RevokeInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Session_RevokeInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Session.RevokeInfo',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.sessions.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'revoked')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'revokedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session_RevokeInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session_RevokeInfo copyWith(void Function(Session_RevokeInfo) updates) =>
      super.copyWith((message) => updates(message as Session_RevokeInfo))
          as Session_RevokeInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Session_RevokeInfo create() => Session_RevokeInfo._();
  @$core.override
  Session_RevokeInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Session_RevokeInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Session_RevokeInfo>(create);
  static Session_RevokeInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get revoked => $_getBF(0);
  @$pb.TagNumber(1)
  set revoked($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRevoked() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevoked() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get revokedAt => $_getN(1);
  @$pb.TagNumber(2)
  set revokedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRevokedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevokedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureRevokedAt() => $_ensure(1);
}

class Session extends $pb.GeneratedMessage {
  factory Session({
    $core.String? id,
    $core.String? hash,
    Session_RevokeInfo? revoke,
    $0.Timestamp? createdAt,
    $0.Timestamp? expiresAt,
    $0.Timestamp? lastSeen,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (hash != null) result.hash = hash;
    if (revoke != null) result.revoke = revoke;
    if (createdAt != null) result.createdAt = createdAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (lastSeen != null) result.lastSeen = lastSeen;
    return result;
  }

  Session._();

  factory Session.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Session.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Session',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.sessions.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'hash')
    ..aOM<Session_RevokeInfo>(3, _omitFieldNames ? '' : 'revoke',
        subBuilder: Session_RevokeInfo.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'lastSeen',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session copyWith(void Function(Session) updates) =>
      super.copyWith((message) => updates(message as Session)) as Session;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Session create() => Session._();
  @$core.override
  Session createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Session getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Session>(create);
  static Session? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hash => $_getSZ(1);
  @$pb.TagNumber(2)
  set hash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearHash() => $_clearField(2);

  @$pb.TagNumber(3)
  Session_RevokeInfo get revoke => $_getN(2);
  @$pb.TagNumber(3)
  set revoke(Session_RevokeInfo value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRevoke() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevoke() => $_clearField(3);
  @$pb.TagNumber(3)
  Session_RevokeInfo ensureRevoke() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get createdAt => $_getN(3);
  @$pb.TagNumber(4)
  set createdAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCreatedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureCreatedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get expiresAt => $_getN(4);
  @$pb.TagNumber(5)
  set expiresAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureExpiresAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get lastSeen => $_getN(5);
  @$pb.TagNumber(6)
  set lastSeen($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLastSeen() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastSeen() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureLastSeen() => $_ensure(5);
}

class SessionsListResponse extends $pb.GeneratedMessage {
  factory SessionsListResponse({
    $core.Iterable<Session>? list,
  }) {
    final result = create();
    if (list != null) result.list.addAll(list);
    return result;
  }

  SessionsListResponse._();

  factory SessionsListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionsListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionsListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'xyz.secureguard.v1.sessions.v1'),
      createEmptyInstance: create)
    ..pPM<Session>(1, _omitFieldNames ? '' : 'list', subBuilder: Session.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionsListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionsListResponse copyWith(void Function(SessionsListResponse) updates) =>
      super.copyWith((message) => updates(message as SessionsListResponse))
          as SessionsListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionsListResponse create() => SessionsListResponse._();
  @$core.override
  SessionsListResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionsListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionsListResponse>(create);
  static SessionsListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Session> get list => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
