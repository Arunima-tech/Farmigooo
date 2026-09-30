import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImageHelper {
  static final _picker = ImagePicker();

  // Opens the file picker, resizes the chosen image down to a max width,
  // and returns it as a base64 string ready to store in Firestore.
  // Returns null if the user cancelled.
  static Future<String?> pickAndEncodeImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // initial compression from the picker itself
    );
    if (file == null) return null;

    final Uint8List bytes = await file.readAsBytes();
    final img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) return null;

    // Resize down to max 600px wide, keeping aspect ratio, to keep file size small.
    final img.Image resized = decoded.width > 600
        ? img.copyResize(decoded, width: 600)
        : decoded;

    final Uint8List compressedBytes =
        Uint8List.fromList(img.encodeJpg(resized, quality: 70));

    return base64Encode(compressedBytes);
  }
}
