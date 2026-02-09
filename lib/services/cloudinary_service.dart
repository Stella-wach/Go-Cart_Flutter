import 'package:cloudinary_public/cloudinary_public.dart';
import 'dart:io';

class CloudinaryService {
  // Replace with your Cloudinary credentials
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String uploadPreset = 'YOUR_UPLOAD_PRESET';
  
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
}