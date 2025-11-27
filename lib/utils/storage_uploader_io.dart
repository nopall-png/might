import 'dart:async';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import '../data/services/appwrite_service.dart';
import '../data/services/appwrite_config.dart';
import 'package:image/image.dart' as img;

Future<String> uploadUserPhoto({
  required XFile xfile,
  required String uid,
}) async {
  final storage = AppwriteService.instance.storage;
  final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  final fileId = ID.unique();
  try {
    final originalBytes = await xfile.readAsBytes();
    final processedBytes = _compressAndCropSquare(originalBytes);
    await storage.createFile(
      bucketId: AppwriteConfig.storageBucketId,
      fileId: fileId,
      file: InputFile.fromBytes(bytes: processedBytes, filename: filename),
      permissions: [
        // Buat foto dapat dilihat publik tanpa cookie sesi Appwrite
        Permission.read(Role.any()),
        Permission.update(Role.user(uid)),
      ],
    );
  } catch (_) {
    final file = io.File(xfile.path);
    // Fallback: baca dari path lalu kompres/crop
    final originalBytes = await file.readAsBytes();
    final processedBytes = _compressAndCropSquare(originalBytes);
    await storage.createFile(
      bucketId: AppwriteConfig.storageBucketId,
      fileId: fileId,
      file: InputFile.fromBytes(bytes: processedBytes, filename: filename),
      permissions: [
        // Buat foto dapat dilihat publik tanpa cookie sesi Appwrite
        Permission.read(Role.any()),
        Permission.update(Role.user(uid)),
      ],
    );
  }
  return _buildViewUrl(fileId);
}

String _buildViewUrl(String fileId) {
  // Dengan Permission.read(Role.any()), URL ini dapat diakses publik tanpa cookie sesi.
  final base = AppwriteConfig.endpoint;
  final project = AppwriteConfig.projectId;
  return '$base/storage/buckets/${AppwriteConfig.storageBucketId}/files/$fileId/view?project=$project';
}

/// Kompres ke JPEG (~80% quality), crop center menjadi square, dan resize
/// ke max 1024x1024 agar hemat storage dan konsisten dengan frame avatar.
Uint8List _compressAndCropSquare(Uint8List inputBytes) {
  try {
    img.Image? image = img.decodeImage(inputBytes);
    if (image == null) return inputBytes; // fallback tanpa modifikasi

    // Terapkan orientasi EXIF agar tidak terbalik di perangkat tertentu
    image = img.bakeOrientation(image);

    final minSide = image.width < image.height ? image.width : image.height;
    final left = (image.width - minSide) ~/ 2;
    final top = (image.height - minSide) ~/ 2;
    img.Image square = img.copyCrop(
      image,
      x: left,
      y: top,
      width: minSide,
      height: minSide,
    );

    const maxDim = 1024;
    if (square.width > maxDim) {
      square = img.copyResize(square, width: maxDim, height: maxDim);
    }

    final jpg = img.encodeJpg(square, quality: 80);
    return Uint8List.fromList(jpg);
  } catch (_) {
    // Jika ada error pada kompres/crop, kembalikan bytes asli
    return inputBytes;
  }
}

Future<String> uploadUserPhotoBytes({
  required Uint8List bytes,
  required String uid,
}) async {
  final storage = AppwriteService.instance.storage;
  final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
  final fileId = ID.unique();
  final processedBytes = _compressAfterCrop(bytes);
  await storage.createFile(
    bucketId: AppwriteConfig.storageBucketId,
    fileId: fileId,
    file: InputFile.fromBytes(bytes: processedBytes, filename: filename),
    permissions: [
      Permission.read(Role.any()),
      Permission.update(Role.user(uid)),
    ],
  );
  return _buildViewUrl(fileId);
}

/// Asumsinya bytes sudah hasil crop square dari UI; hanya pastikan orientasi
/// benar, resize ke max dimensi, lalu kompres JPEG kualitas 80.
Uint8List _compressAfterCrop(Uint8List inputBytes) {
  try {
    img.Image? image = img.decodeImage(inputBytes);
    if (image == null) return inputBytes;
    image = img.bakeOrientation(image);
    const maxDim = 1024;
    if (image.width > maxDim) {
      image = img.copyResize(image, width: maxDim, height: maxDim);
    }
    final jpg = img.encodeJpg(image, quality: 80);
    return Uint8List.fromList(jpg);
  } catch (_) {
    return inputBytes;
  }
}
