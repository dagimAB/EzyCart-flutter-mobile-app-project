import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  /// Uploads an image file to Cloudinary using an unsigned upload preset.
  /// Supports both Mobile (File Path) and Web (Bytes).
  static Future<String?> uploadImage(String filePath, {XFile? file}) async {
    final cloudName = (dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '').trim();
    final uploadPreset = (dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '').trim();

    if (cloudName.isEmpty || uploadPreset.isEmpty) {
      throw Exception(
        'Cloudinary is not configured. Set CLOUDINARY_CLOUD_NAME and CLOUDINARY_UPLOAD_PRESET in .env',
      );
    }

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = uploadPreset;

    if (file != null) {
      // Use bytes for better compatibility (especially Web) - checking if XFile is provided
      final bytes = await file.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: file.name),
      );
    } else {
      // Fallback to path if only path provided (Mobile legacy)
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonResp = jsonDecode(response.body) as Map<String, dynamic>;
      return jsonResp['secure_url'] as String?;
    } else {
      throw Exception(
        'Cloudinary Error: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
