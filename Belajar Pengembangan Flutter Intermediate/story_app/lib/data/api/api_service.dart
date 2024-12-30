import 'dart:convert';
import 'dart:typed_data';
import 'package:declarative_navigation/data/model/login_result.dart';
import 'package:declarative_navigation/data/model/register_result.dart';
import 'package:declarative_navigation/data/model/story_result.dart';
import 'package:declarative_navigation/data/model/story_detail_result.dart';
import 'package:declarative_navigation/data/model/upload_result.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/register"),
      body: {
        "name": name,
        "email": email,
        "password": password,
      },
    );
    if (response.statusCode == 201) {
      return RegisterResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal register user');
    }
  }

  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(Uri.parse("$_baseUrl/login"), body: {
      "email": email,
      "password": password,
    });
    if (response.statusCode == 200) {
      return LoginResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Email atau password kamu tidak valid');
    }
  }

  Future<StoryResult> getAllStories({
    required String token,
    required int pageItems,
    required int sizeItems,
  }) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/stories").replace(queryParameters: {
        'page': pageItems.toString(),
        'size': sizeItems.toString(),
      }),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return StoryResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mendapatkan data stories');
    }
  }

  Future<StoryDetailResult> getDetailStory(
      {required String token, required String id}) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/stories/$id"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return StoryDetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mendapatkan data detail story');
    }
  }

  Future<UploadResult> uploadDocument(
    List<int> bytes,
    String fileName,
    String description,
    String token,
    double? lat,
    double? lon,
  ) async {
    final uri = Uri.parse("$_baseUrl/stories");
    var request = http.MultipartRequest('POST', uri);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
    };

    if (lat != null && lon != null) {
      fields['lat'] = lat.toString();
      fields['lon'] = lon.toString();
    }

    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'Authorization': 'Bearer $token',
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(responseData);

      final UploadResult uploadResult = UploadResult.fromJson(
        jsonResponse,
      );
      return uploadResult;
    } else {
      throw Exception("Upload file error");
    }
  }
}
