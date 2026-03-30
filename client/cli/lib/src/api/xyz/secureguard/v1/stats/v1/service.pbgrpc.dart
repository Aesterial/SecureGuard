// This is a generated file - do not edit.
//
// Generated from xyz/secureguard/v1/stats/v1/service.proto.

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

@$pb.GrpcServiceName('xyz.secureguard.v1.stats.v1.StatsService')
class StatsServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  StatsServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$1.StatsResponse> today(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$today, request, options: options);
  }

  $grpc.ResponseFuture<$1.StatsResponse> byDate(
    $1.ByDateRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$byDate, request, options: options);
  }

  $grpc.ResponseFuture<$1.TotalResponse> total(
    $0.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$total, request, options: options);
  }

  // method descriptors

  static final _$today = $grpc.ClientMethod<$0.Empty, $1.StatsResponse>(
      '/xyz.secureguard.v1.stats.v1.StatsService/Today',
      ($0.Empty value) => value.writeToBuffer(),
      $1.StatsResponse.fromBuffer);
  static final _$byDate =
      $grpc.ClientMethod<$1.ByDateRequest, $1.StatsResponse>(
          '/xyz.secureguard.v1.stats.v1.StatsService/ByDate',
          ($1.ByDateRequest value) => value.writeToBuffer(),
          $1.StatsResponse.fromBuffer);
  static final _$total = $grpc.ClientMethod<$0.Empty, $1.TotalResponse>(
      '/xyz.secureguard.v1.stats.v1.StatsService/Total',
      ($0.Empty value) => value.writeToBuffer(),
      $1.TotalResponse.fromBuffer);
}

@$pb.GrpcServiceName('xyz.secureguard.v1.stats.v1.StatsService')
abstract class StatsServiceBase extends $grpc.Service {
  $core.String get $name => 'xyz.secureguard.v1.stats.v1.StatsService';

  StatsServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.StatsResponse>(
        'Today',
        today_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.StatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ByDateRequest, $1.StatsResponse>(
        'ByDate',
        byDate_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ByDateRequest.fromBuffer(value),
        ($1.StatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $1.TotalResponse>(
        'Total',
        total_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($1.TotalResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.StatsResponse> today_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return today($call, await $request);
  }

  $async.Future<$1.StatsResponse> today(
      $grpc.ServiceCall call, $0.Empty request);

  $async.Future<$1.StatsResponse> byDate_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.ByDateRequest> $request) async {
    return byDate($call, await $request);
  }

  $async.Future<$1.StatsResponse> byDate(
      $grpc.ServiceCall call, $1.ByDateRequest request);

  $async.Future<$1.TotalResponse> total_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Empty> $request) async {
    return total($call, await $request);
  }

  $async.Future<$1.TotalResponse> total(
      $grpc.ServiceCall call, $0.Empty request);
}
