// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/meta/v1/service.proto.

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

import 'domain.pb.dart' as $1;

export 'service.pb.dart';

@$pb.GrpcServiceName('xyz.secureguard.api.v1.meta.v1.MetaService')
class MetaServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  MetaServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$1.ServerInfoResponse> serverInformation(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$serverInformation, request, options: options);
  }

  $grpc.ResponseFuture<$1.CompatibilityResponse> clientCompatibility(
    $1.CompatibilityRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$clientCompatibility, request, options: options);
  }

  $grpc.ResponseFuture<$1.LocalisationResponse> localisation(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$localisation, request, options: options);
  }

  // method descriptors

  static final _$serverInformation =
      $grpc.ClientMethod<$0.Empty, $1.ServerInfoResponse>(
          '/xyz.secureguard.api.v1.meta.v1.MetaService/ServerInformation',
          ($0.Empty value) => value.writeToBuffer(),
          $1.ServerInfoResponse.fromBuffer);
  static final _$clientCompatibility =
      $grpc.ClientMethod<$1.CompatibilityRequest, $1.CompatibilityResponse>(
          '/xyz.secureguard.api.v1.meta.v1.MetaService/ClientCompatibility',
          ($1.CompatibilityRequest value) => value.writeToBuffer(),
          $1.CompatibilityResponse.fromBuffer);
  static final _$localisation =
      $grpc.ClientMethod<$0.Empty, $1.LocalisationResponse>(
          '/xyz.secureguard.api.v1.meta.v1.MetaService/Localisation',
          ($0.Empty value) => value.writeToBuffer(),
          $1.LocalisationResponse.fromBuffer);
}

@$pb.GrpcServiceName('xyz.secureguard.api.v1.meta.v1.MetaService')
abstract class MetaServiceBase extends $grpc.Service {
  $core.String get $name => 'xyz.secureguard.api.v1.meta.v1.MetaService';

  MetaServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.ServerInfoResponse>(
        'ServerInformation',
        serverInformation_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.ServerInfoResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$1.CompatibilityRequest, $1.CompatibilityResponse>(
            'ClientCompatibility',
            clientCompatibility_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $1.CompatibilityRequest.fromBuffer(value),
            ($1.CompatibilityResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.LocalisationResponse>(
        'Localisation',
        localisation_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.LocalisationResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.ServerInfoResponse> serverInformation_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return serverInformation($call, await $request);
  }

  $async.Future<$1.ServerInfoResponse> serverInformation(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.CompatibilityResponse> clientCompatibility_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$1.CompatibilityRequest> $request) async {
    return clientCompatibility($call, await $request);
  }

  $async.Future<$1.CompatibilityResponse> clientCompatibility(
      $grpc.ServiceCall call, $1.CompatibilityRequest request);

  $async.Future<$1.LocalisationResponse> localisation_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return localisation($call, await $request);
  }

  $async.Future<$1.LocalisationResponse> localisation(
      $grpc.ServiceCall call, $0.Empty request);
}
