import 'package:declarative_navigation/data/api/api_service.dart';
import 'package:declarative_navigation/data/db/auth_repository.dart';
import 'package:declarative_navigation/data/model/upload_result.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class UploadProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  UploadProvider({required this.authRepository, required this.apiService});

  bool isUploading = false;
  String message = "";
  UploadResult? uploadResult;

  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description,
    double? lat,
    double? lon,
  ) async {
    try {
      message = "";
      uploadResult = null;
      isUploading = true;
      notifyListeners();
      final token = await authRepository.getToken();
      uploadResult = await apiService.uploadDocument(
        bytes,
        fileName,
        description,
        token ?? '',
        lat,
        lon,
      );
      message = uploadResult?.message ?? "success";
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      ///
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }
}
