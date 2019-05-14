///
//  Generated code. Do not modify.
//  source: files.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

class FilesPart extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FilesPart', package: const $pb.PackageName('rushio.coverage'))
    ..aOS(1, 'id')
    ..a<List<int>>(2, 'bytes', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  FilesPart() : super();
  FilesPart.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FilesPart.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FilesPart clone() => new FilesPart()..mergeFromMessage(this);
  FilesPart copyWith(void Function(FilesPart) updates) => super.copyWith((message) => updates(message as FilesPart));
  $pb.BuilderInfo get info_ => _i;
  static FilesPart create() => new FilesPart();
  FilesPart createEmptyInstance() => create();
  static $pb.PbList<FilesPart> createRepeated() => new $pb.PbList<FilesPart>();
  static FilesPart getDefault() => _defaultInstance ??= create()..freeze();
  static FilesPart _defaultInstance;
  static void $checkItem(FilesPart v) {
    if (v is! FilesPart) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get id => $_getS(0, '');
  set id(String v) { $_setString(0, v); }
  bool hasId() => $_has(0);
  void clearId() => clearField(1);

  List<int> get bytes => $_getN(1);
  set bytes(List<int> v) { $_setBytes(1, v); }
  bool hasBytes() => $_has(1);
  void clearBytes() => clearField(2);
}

