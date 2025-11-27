import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:crop_your_image/crop_your_image.dart';

Future<Uint8List?> showAvatarCropper(
  BuildContext context,
  Uint8List imageBytes,
) {
  return showDialog<Uint8List?>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      final controller = CropController();
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: double.infinity,
          height: 520,
          child: Column(
            children: [
              Container(
                height: 56,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7A3FFF), Color(0xFFA96CFF)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(ctx, null),
                    ),
                    const Text(
                      'Crop Avatar',
                      style: TextStyle(
                        fontFamily: 'Press Start 2P',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: () async {
                        controller.crop();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Crop(
                    controller: controller,
                    image: imageBytes,
                    aspectRatio: 1.0, // square crop for avatar
                    withCircleUi: false,
                    onCropped: (result) {
                      try {
                        final dynamic r = result;
                        final Uint8List? bytes = r.croppedImage is Uint8List
                            ? r.croppedImage as Uint8List
                            : null;
                        Navigator.pop(ctx, bytes);
                      } catch (_) {
                        Navigator.pop(ctx, null);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
