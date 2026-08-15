// This is a generated file - do not edit.
//
// Generated from schema.proto.

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

import 'schema.pb.dart' as $0;

export 'schema.pb.dart';

@$pb.GrpcServiceName('HelloService')
class HelloServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  HelloServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.Hello> sayHello(
    $0.Hello request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sayHello, request, options: options);
  }

  // method descriptors

  static final _$sayHello = $grpc.ClientMethod<$0.Hello, $0.Hello>(
      '/HelloService/SayHello',
      ($0.Hello value) => value.writeToBuffer(),
      $0.Hello.fromBuffer);
}

@$pb.GrpcServiceName('HelloService')
abstract class HelloServiceBase extends $grpc.Service {
  $core.String get $name => 'HelloService';

  HelloServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Hello, $0.Hello>(
        'SayHello',
        sayHello_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Hello.fromBuffer(value),
        ($0.Hello value) => value.writeToBuffer()));
  }

  $async.Future<$0.Hello> sayHello_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.Hello> $request) async {
    return sayHello($call, await $request);
  }

  $async.Future<$0.Hello> sayHello($grpc.ServiceCall call, $0.Hello request);
}
