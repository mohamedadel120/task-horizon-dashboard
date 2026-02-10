import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImagePickerService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Pick image from device
  Future<PlatformFile?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
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
    required String folder, // 'categories' or 'products'
  }) async {
    try {
      // Validate file
      if (file.bytes == null) {
        throw Exception('File data is empty');
      }

      // Generate unique filename
      final String fileName = '${_uuid.v4()}_${file.name}';
      final String path = '$folder/$fileName';

      // Upload to Firebase Storage
      final Reference ref = _storage.ref().child(path);
      final UploadTask uploadTask = ref.putData(
        file.bytes!,
        SettableMetadata(contentType: _getContentType(file.extension)),
      );

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Delete image from Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
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
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  /// Pick and upload image in one step
  Future<String?> pickAndUploadImage(String folder) async {
    try {
      final file = await pickImage();
      if (file == null) return null;

      final downloadUrl = await uploadImage(file: file, folder: folder);
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to pick and upload image: $e');
    }
  }
}
