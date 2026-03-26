// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/users/v1/service.proto.

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
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart' as $0;

import '../../types.pb.dart' as $2;
import 'domain.pb.dart' as $1;

export 'service.pb.dart';

@$pb.GrpcServiceName('xyz.secureguard.v1.users.v1.UserService')
class UserServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  UserServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$1.UserResponse> info(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$info, request, options: options);
  }

  $grpc.ResponseFuture<$1.ChangeThemeResponse> changeTheme(
    $1.ChangeThemeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$changeTheme, request, options: options);
  }

  $grpc.ResponseFuture<$1.ChangeLanguageResponse> changeLanguage(
    $1.ChangeLanguageRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$changeLanguage, request, options: options);
  }

  $grpc.ResponseFuture<$1.ChangeCryptResponse> changeCrypt(
    $1.ChangeCryptRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$changeCrypt, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> changeKey(
    $2.RequestWithValueAndKdf request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$changeKey, request, options: options);
  }

  // method descriptors

  static final _$info = $grpc.ClientMethod<$0.Empty, $1.UserResponse>(
      '/xyz.secureguard.v1.users.v1.UserService/Info',
      ($0.Empty value) => value.writeToBuffer(),
      $1.UserResponse.fromBuffer);
  static final _$changeTheme =
      $grpc.ClientMethod<$1.ChangeThemeRequest, $1.ChangeThemeResponse>(
          '/xyz.secureguard.v1.users.v1.UserService/ChangeTheme',
          ($1.ChangeThemeRequest value) => value.writeToBuffer(),
          $1.ChangeThemeResponse.fromBuffer);
  static final _$changeLanguage =
      $grpc.ClientMethod<$1.ChangeLanguageRequest, $1.ChangeLanguageResponse>(
          '/xyz.secureguard.v1.users.v1.UserService/ChangeLanguage',
          ($1.ChangeLanguageRequest value) => value.writeToBuffer(),
          $1.ChangeLanguageResponse.fromBuffer);
  static final _$changeCrypt =
      $grpc.ClientMethod<$1.ChangeCryptRequest, $1.ChangeCryptResponse>(
          '/xyz.secureguard.v1.users.v1.UserService/ChangeCrypt',
          ($1.ChangeCryptRequest value) => value.writeToBuffer(),
          $1.ChangeCryptResponse.fromBuffer);
  static final _$changeKey =
      $grpc.ClientMethod<$2.RequestWithValueAndKdf, $0.Empty>(
          '/xyz.secureguard.v1.users.v1.UserService/ChangeKey',
          ($2.RequestWithValueAndKdf value) => value.writeToBuffer(),
          $0.Empty.fromBuffer);
}

@$pb.GrpcServiceName('xyz.secureguard.v1.users.v1.UserService')
abstract class UserServiceBase extends $grpc.Service {
  $core.String get $name => 'xyz.secureguard.v1.users.v1.UserService';

  UserServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.UserResponse>(
        'Info',
        info_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.UserResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.ChangeThemeRequest, $1.ChangeThemeResponse>(
            'ChangeTheme',
            changeTheme_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.ChangeThemeRequest.fromBuffer(value),
            ($1.ChangeThemeResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ChangeLanguageRequest,
            $1.ChangeLanguageResponse>(
        'ChangeLanguage',
        changeLanguage_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $1.ChangeLanguageRequest.fromBuffer(value),
        ($1.ChangeLanguageResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.ChangeCryptRequest, $1.ChangeCryptResponse>(
            'ChangeCrypt',
            changeCrypt_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.ChangeCryptRequest.fromBuffer(value),
            ($1.ChangeCryptResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.RequestWithValueAndKdf, $0.Empty>(
        'ChangeKey',
        changeKey_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $2.RequestWithValueAndKdf.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$1.UserResponse> info_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return info($call, await $request);
  }

  $async.Future<$1.UserResponse> info($grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.ChangeThemeResponse> changeTheme_Pre($grpc.ServiceCall $call,
      $async.Future<$1.ChangeThemeRequest> $request) async {
    return changeTheme($call, await $request);
  }

  $async.Future<$1.ChangeThemeResponse> changeTheme(
      $grpc.ServiceCall call, $1.ChangeThemeRequest request);

  $async.Future<$1.ChangeLanguageResponse> changeLanguage_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.ChangeLanguageRequest> $request) async {
    return changeLanguage($call, await $request);
  }

  $async.Future<$1.ChangeLanguageResponse> changeLanguage(
      $grpc.ServiceCall call, $1.ChangeLanguageRequest request);

  $async.Future<$1.ChangeCryptResponse> changeCrypt_Pre($grpc.ServiceCall $call,
      $async.Future<$1.ChangeCryptRequest> $request) async {
    return changeCrypt($call, await $request);
  }

  $async.Future<$1.ChangeCryptResponse> changeCrypt(
      $grpc.ServiceCall call, $1.ChangeCryptRequest request);

  $async.Future<$0.Empty> changeKey_Pre($grpc.ServiceCall $call,
      $async.Future<$2.RequestWithValueAndKdf> $request) async {
    return changeKey($call, await $request);
  }

  $async.Future<$0.Empty> changeKey(
      $grpc.ServiceCall call, $2.RequestWithValueAndKdf request);
}
