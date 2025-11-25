import 'dart:async';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadUserPhoto({
  required FirebaseStorage storage,
  required XFile xfile,
  required String uid,
}) async {
  final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  final ref = storage.ref().child('user_profiles/$uid/$filename');
  try {
    final bytes = await xfile.readAsBytes();
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
  } catch (_) {
    final file = io.File(xfile.path);
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
  }
  return await _getUrlWithRetry(ref);
}

Future<String> _getUrlWithRetry(Reference ref) async {
  const maxAttempts = 3;
  int attempt = 0;
  while (true) {
    attempt++;
    try {
      return await ref.getDownloadURL();
    } catch (_) {
      if (attempt >= maxAttempts) rethrow;
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }
}