///
//  Generated code. Do not modify.
//  source: files.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'google/protobuf/empty.pb.dart' as $0;
import 'files.pb.dart';
export 'files.pb.dart';

class FilesServiceClient extends Client {
  static final _$startUploadFiles = new ClientMethod<$0.Empty, $0.Empty>(
      '/rushio.coverage.FilesService/startUploadFiles',
      ($0.Empty value) => value.writeToBuffer(),
      (List<int> value) => new $0.Empty.fromBuffer(value));
  static final _$uploadFilesPart = new ClientMethod<FilesPart, $0.Empty>(
      '/rushio.coverage.FilesService/uploadFilesPart',
      (FilesPart value) => value.writeToBuffer(),
      (List<int> value) => new $0.Empty.fromBuffer(value));

  FilesServiceClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<$0.Empty> startUploadFiles($0.Empty request,
      {CallOptions options}) {
    final call = $createCall(
        _$startUploadFiles, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseFuture<$0.Empty> uploadFilesPart(FilesPart request,
      {CallOptions options}) {
    final call = $createCall(
        _$uploadFilesPart, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }
}

abstract class FilesServiceBase extends Service {
  String get $name => 'rushio.coverage.FilesService';

  FilesServiceBase() {
    $addMethod(new ServiceMethod<$0.Empty, $0.Empty>(
        'startUploadFiles',
        startUploadFiles_Pre,
        false,
        false,
        (List<int> value) => new $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<FilesPart, $0.Empty>(
        'uploadFilesPart',
        uploadFilesPart_Pre,
        false,
        false,
        (List<int> value) => new FilesPart.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.Empty> startUploadFiles_Pre(
      ServiceCall call, $async.Future request) async {
    return startUploadFiles(call, await request);
  }

  $async.Future<$0.Empty> uploadFilesPart_Pre(
      ServiceCall call, $async.Future request) async {
    return uploadFilesPart(call, await request);
  }

  $async.Future<$0.Empty> startUploadFiles(ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> uploadFilesPart(ServiceCall call, FilesPart request);
}
