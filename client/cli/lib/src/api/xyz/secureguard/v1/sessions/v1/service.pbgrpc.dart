// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/sessions/v1/service.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart' as $2;

import '../../types.pb.dart' as $0;
import 'domain.pb.dart' as $1;

export 'service.pb.dart';

@$pb.GrpcServiceName('xyz.secureguard.v1.sessions.v1.SessionsService')
class SessionsServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SessionsServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$1.SessionsListResponse> getList(
    $0.RequestWithBooleanLimitOffset request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getList, request, options: options);
  }

  $grpc.ResponseFuture<$2.Empty> revoke(
    $0.RequestWithID request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$revoke, request, options: options);
  }

  // method descriptors

  static final _$getList = $grpc.ClientMethod<$0.RequestWithBooleanLimitOffset,
          $1.SessionsListResponse>(
      '/xyz.secureguard.v1.sessions.v1.SessionsService/GetList',
      ($0.RequestWithBooleanLimitOffset value) => value.writeToBuffer(),
      $1.SessionsListResponse.fromBuffer);
  static final _$revoke = $grpc.ClientMethod<$0.RequestWithID, $2.Empty>(
      '/xyz.secureguard.v1.sessions.v1.SessionsService/Revoke',
      ($0.RequestWithID value) => value.writeToBuffer(),
      $2.Empty.fromBuffer);
}

@$pb.GrpcServiceName('xyz.secureguard.v1.sessions.v1.SessionsService')
abstract class SessionsServiceBase extends $grpc.Service {
  $core.String get $name => 'xyz.secureguard.v1.sessions.v1.SessionsService';

  SessionsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RequestWithBooleanLimitOffset,
            $1.SessionsListResponse>(
        'GetList',
        getList_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RequestWithBooleanLimitOffset.fromBuffer(value),
        ($1.SessionsListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RequestWithID, $2.Empty>(
        'Revoke',
        revoke_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RequestWithID.fromBuffer(value),
        ($2.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$1.SessionsListResponse> getList_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RequestWithBooleanLimitOffset> $request) async {
    return getList($call, await $request);
  }

  $async.Future<$1.SessionsListResponse> getList(
      $grpc.ServiceCall call, $0.RequestWithBooleanLimitOffset request);

  $async.Future<$2.Empty> revoke_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.RequestWithID> $request) async {
    return revoke($call, await $request);
  }

  $async.Future<$2.Empty> revoke(
      $grpc.ServiceCall call, $0.RequestWithID request);
}
