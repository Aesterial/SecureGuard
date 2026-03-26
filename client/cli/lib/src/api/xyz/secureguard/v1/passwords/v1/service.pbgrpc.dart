// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/passwords/v1/service.proto.

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

import '../../types.pb.dart' as $0;
import 'domain.pb.dart' as $1;

export 'service.pb.dart';

@$pb.GrpcServiceName('xyz.secureguard.v1.passwords.v1.PasswordService')
class PasswordServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PasswordServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$1.ListResponse> list(
    $0.RequestWithLimitAndOffset request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$1.PassDataResponse> create(
    $1.CreateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$create, request, options: options);
  }

  $grpc.ResponseFuture<$1.PassDataResponse> update(
    $1.UpdateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$update, request, options: options);
  }

  $grpc.ResponseFuture<$1.DeleteResponse> delete(
    $0.RequestWithID request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$delete, request, options: options);
  }

  // method descriptors

  static final _$list =
      $grpc.ClientMethod<$0.RequestWithLimitAndOffset, $1.ListResponse>(
          '/xyz.secureguard.v1.passwords.v1.PasswordService/List',
          ($0.RequestWithLimitAndOffset value) => value.writeToBuffer(),
          $1.ListResponse.fromBuffer);
  static final _$create =
      $grpc.ClientMethod<$1.CreateRequest, $1.PassDataResponse>(
          '/xyz.secureguard.v1.passwords.v1.PasswordService/Create',
          ($1.CreateRequest value) => value.writeToBuffer(),
          $1.PassDataResponse.fromBuffer);
  static final _$update =
      $grpc.ClientMethod<$1.UpdateRequest, $1.PassDataResponse>(
          '/xyz.secureguard.v1.passwords.v1.PasswordService/Update',
          ($1.UpdateRequest value) => value.writeToBuffer(),
          $1.PassDataResponse.fromBuffer);
  static final _$delete =
      $grpc.ClientMethod<$0.RequestWithID, $1.DeleteResponse>(
          '/xyz.secureguard.v1.passwords.v1.PasswordService/Delete',
          ($0.RequestWithID value) => value.writeToBuffer(),
          $1.DeleteResponse.fromBuffer);
}

@$pb.GrpcServiceName('xyz.secureguard.v1.passwords.v1.PasswordService')
abstract class PasswordServiceBase extends $grpc.Service {
  $core.String get $name => 'xyz.secureguard.v1.passwords.v1.PasswordService';

  PasswordServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.RequestWithLimitAndOffset, $1.ListResponse>(
            'List',
            list_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RequestWithLimitAndOffset.fromBuffer(value),
            ($1.ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.CreateRequest, $1.PassDataResponse>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.CreateRequest.fromBuffer(value),
        ($1.PassDataResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.UpdateRequest, $1.PassDataResponse>(
        'Update',
        update_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.UpdateRequest.fromBuffer(value),
        ($1.PassDataResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RequestWithID, $1.DeleteResponse>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RequestWithID.fromBuffer(value),
        ($1.DeleteResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.ListResponse> list_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RequestWithLimitAndOffset> $request) async {
    return list($call, await $request);
  }

  $async.Future<$1.ListResponse> list(
      $grpc.ServiceCall call, $0.RequestWithLimitAndOffset request);

  $async.Future<$1.PassDataResponse> create_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.CreateRequest> $request) async {
    return create($call, await $request);
  }

  $async.Future<$1.PassDataResponse> create(
      $grpc.ServiceCall call, $1.CreateRequest request);

  $async.Future<$1.PassDataResponse> update_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.UpdateRequest> $request) async {
    return update($call, await $request);
  }

  $async.Future<$1.PassDataResponse> update(
      $grpc.ServiceCall call, $1.UpdateRequest request);

  $async.Future<$1.DeleteResponse> delete_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.RequestWithID> $request) async {
    return delete($call, await $request);
  }

  $async.Future<$1.DeleteResponse> delete(
      $grpc.ServiceCall call, $0.RequestWithID request);
}
