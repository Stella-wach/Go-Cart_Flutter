import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';
import 'dart:typed_data';

class CloudinaryService {
  // Replace with your Cloudinary credentials
  static const String cloudName = 'dem0gquvk';
  static const String uploadPreset = 'globe_app_products';
  
  final cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);

  Future<String?> uploadImage(File imageFile, {String? folder}) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: folder ?? 'globe_app',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Upload from bytes (for web)
  Future<String?> uploadImageBytes(Uint8List bytes, String fileName, {String? folder}) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          bytes,
          identifier: fileName,
          folder: folder ?? 'globe_app',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages(
    List<File> imageFiles, {
    String? folder,
  }) async {
    List<String> urls = [];
    
    for (var imageFile in imageFiles) {
      final url = await uploadImage(imageFile, folder: folder);
      if (url != null) {
        urls.add(url);
      }
    }
    
    return urls;
  }

  // Upload multiple images from bytes (for web)
  Future<List<String>> uploadMultipleImageBytes(
    List<Uint8List> imageBytes, {
    String? folder,
  }) async {
    List<String> urls = [];
    
    for (int i = 0; i < imageBytes.length; i++) {
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final url = await uploadImageBytes(imageBytes[i], fileName, folder: folder);
      if (url != null) {
        urls.add(url);
      }
    }
    
    return urls;
  }
}