import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

/// Reusable service for handling image uploads to Firebase Storage
class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Pick image from local device
  Future<PlatformFile?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
        withData: true, // Important for web
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.first;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Upload image to Firebase Storage
  Future<String> uploadImage({
    required PlatformFile file,
    required String folder,
  }) async {
    try {
      // Generate unique filename
      final String fileName = '${_uuid.v4()}_${file.name}';
      final String path = '$folder/$fileName';

      // Get file bytes (works for web and mobile)
      final bytes = file.bytes;
      if (bytes == null) {
        throw Exception('Failed to read file bytes');
      }

      // Create storage reference
      final Reference ref = _storage.ref().child(path);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: _getContentType(file.extension),
      );

      // Upload file
      final UploadTask uploadTask = ref.putData(bytes, metadata);

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Pick and upload image in one operation
  Future<String?> pickAndUploadImage(String folder) async {
    final file = await pickImage();
    if (file == null) return null;

    return await uploadImage(file: file, folder: folder);
  }

  /// Delete image from Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Silently fail if image doesn't exist or can't be deleted
      return;
    }
  }

  /// Get content type from file extension
  String _getContentType(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
