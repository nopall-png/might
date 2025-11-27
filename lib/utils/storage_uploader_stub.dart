import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

Future<String> uploadUserPhoto({
  required XFile xfile,
  required String uid,
}) async => throw UnimplementedError('Storage uploader not implemented for this platform');

Future<String> uploadUserPhotoBytes({
  required Uint8List bytes,
  required String uid,
}) async => throw UnimplementedError('Storage uploader not implemented for this platform');
