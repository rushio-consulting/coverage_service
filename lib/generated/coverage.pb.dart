///
//  Generated code. Do not modify.
//  source: coverage.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class GetCoverageRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetCoverageRequest', package: const $pb.PackageName('rushio.coverage'))
    ..a<List<int>>(1, 'zip', $pb.PbFieldType.OY)
    ..aOB(2, 'deleteFolder')
    ..aOS(3, 'id')
    ..aOS(4, 'reportOn')
    ..hasRequiredFields = false
  ;

  GetCoverageRequest() : super();
  GetCoverageRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetCoverageRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetCoverageRequest clone() => new GetCoverageRequest()..mergeFromMessage(this);
  GetCoverageRequest copyWith(void Function(GetCoverageRequest) updates) => super.copyWith((message) => updates(message as GetCoverageRequest));
  $pb.BuilderInfo get info_ => _i;
  static GetCoverageRequest create() => new GetCoverageRequest();
  GetCoverageRequest createEmptyInstance() => create();
  static $pb.PbList<GetCoverageRequest> createRepeated() => new $pb.PbList<GetCoverageRequest>();
  static GetCoverageRequest getDefault() => _defaultInstance ??= create()..freeze();
  static GetCoverageRequest _defaultInstance;
  static void $checkItem(GetCoverageRequest v) {
    if (v is! GetCoverageRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get zip => $_getN(0);
  set zip(List<int> v) { $_setBytes(0, v); }
  bool hasZip() => $_has(0);
  void clearZip() => clearField(1);

  bool get deleteFolder => $_get(1, false);
  set deleteFolder(bool v) { $_setBool(1, v); }
  bool hasDeleteFolder() => $_has(1);
  void clearDeleteFolder() => clearField(2);

  String get id => $_getS(2, '');
  set id(String v) { $_setString(2, v); }
  bool hasId() => $_has(2);
  void clearId() => clearField(3);

  String get reportOn => $_getS(3, '');
  set reportOn(String v) { $_setString(3, v); }
  bool hasReportOn() => $_has(3);
  void clearReportOn() => clearField(4);
}

class GetCoverageResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GetCoverageResponse', package: const $pb.PackageName('rushio.coverage'))
    ..a<double>(1, 'coverage', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  GetCoverageResponse() : super();
  GetCoverageResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GetCoverageResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GetCoverageResponse clone() => new GetCoverageResponse()..mergeFromMessage(this);
  GetCoverageResponse copyWith(void Function(GetCoverageResponse) updates) => super.copyWith((message) => updates(message as GetCoverageResponse));
  $pb.BuilderInfo get info_ => _i;
  static GetCoverageResponse create() => new GetCoverageResponse();
  GetCoverageResponse createEmptyInstance() => create();
  static $pb.PbList<GetCoverageResponse> createRepeated() => new $pb.PbList<GetCoverageResponse>();
  static GetCoverageResponse getDefault() => _defaultInstance ??= create()..freeze();
  static GetCoverageResponse _defaultInstance;
  static void $checkItem(GetCoverageResponse v) {
    if (v is! GetCoverageResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  double get coverage => $_getN(0);
  set coverage(double v) { $_setDouble(0, v); }
  bool hasCoverage() => $_has(0);
  void clearCoverage() => clearField(1);
}

