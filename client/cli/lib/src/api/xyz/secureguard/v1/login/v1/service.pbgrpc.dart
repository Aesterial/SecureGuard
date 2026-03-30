// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/login/v1/service.proto.

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
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart' as $1;

import 'domain.pb.dart' as $0;

export 'service.pb.dart';

@$pb.GrpcServiceName('xyz.secureguard.v1.login.v1.LoginService')
class LoginServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  LoginServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.LoginResponse> register(
    $0.RegisterRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$register, request, options: options);
  }

  $grpc.ResponseFuture<$0.LoginResponse> authorize(
    $0.AuthorizeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$authorize, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> logout(
    $1.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$logout, request, options: options);
  }

  // method descriptors

  static final _$register =
      $grpc.ClientMethod<$0.RegisterRequest, $0.LoginResponse>(
          '/xyz.secureguard.v1.login.v1.LoginService/Register',
          ($0.RegisterRequest value) => value.writeToBuffer(),
          $0.LoginResponse.fromBuffer);
  static final _$authorize =
      $grpc.ClientMethod<$0.AuthorizeRequest, $0.LoginResponse>(
          '/xyz.secureguard.v1.login.v1.LoginService/Authorize',
          ($0.AuthorizeRequest value) => value.writeToBuffer(),
          $0.LoginResponse.fromBuffer);
  static final _$logout = $grpc.ClientMethod<$1.Empty, $1.Empty>(
      '/xyz.secureguard.v1.login.v1.LoginService/Logout',
      ($1.Empty value) => value.writeToBuffer(),
      $1.Empty.fromBuffer);
}

@$pb.GrpcServiceName('xyz.secureguard.v1.login.v1.LoginService')
abstract class LoginServiceBase extends $grpc.Service {
  $core.String get $name => 'xyz.secureguard.v1.login.v1.LoginService';

  LoginServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.LoginResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AuthorizeRequest, $0.LoginResponse>(
        'Authorize',
        authorize_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AuthorizeRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $1.Empty>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.LoginResponse> register_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RegisterRequest> $request) async {
    return register($call, await $request);
  }

  $async.Future<$0.LoginResponse> register(
      $grpc.ServiceCall call, $0.RegisterRequest request);

  $async.Future<$0.LoginResponse> authorize_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AuthorizeRequest> $request) async {
    return authorize($call, await $request);
  }

  $async.Future<$0.LoginResponse> authorize(
      $grpc.ServiceCall call, $0.AuthorizeRequest request);

  $async.Future<$1.Empty> logout_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.Empty> $request) async {
    return logout($call, await $request);
  }

  $async.Future<$1.Empty> logout($grpc.ServiceCall call, $1.Empty request);
}
