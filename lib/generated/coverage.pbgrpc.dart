///
//  Generated code. Do not modify.
//  source: coverage.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'coverage.pb.dart';
export 'coverage.pb.dart';

class CoverageServiceClient extends Client {
  static final _$getCoverage =
      new ClientMethod<GetCoverageRequest, GetCoverageResponse>(
          '/rushio.coverage.CoverageService/getCoverage',
          (GetCoverageRequest value) => value.writeToBuffer(),
          (List<int> value) => new GetCoverageResponse.fromBuffer(value));

  CoverageServiceClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<GetCoverageResponse> getCoverage(GetCoverageRequest request,
      {CallOptions options}) {
    final call = $createCall(
        _$getCoverage, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class CoverageServiceBase extends Service {
  String get $name => 'rushio.coverage.CoverageService';

  CoverageServiceBase() {
    $addMethod(new ServiceMethod<GetCoverageRequest, GetCoverageResponse>(
        'getCoverage',
        getCoverage_Pre,
        false,
        false,
        (List<int> value) => new GetCoverageRequest.fromBuffer(value),
        (GetCoverageResponse value) => value.writeToBuffer()));
  }

  $async.Future<GetCoverageResponse> getCoverage_Pre(
      ServiceCall call, $async.Future request) async {
    return getCoverage(call, await request);
  }

  $async.Future<GetCoverageResponse> getCoverage(
      ServiceCall call, GetCoverageRequest request);
}
