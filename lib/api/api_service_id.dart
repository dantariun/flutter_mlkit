import 'dart:convert';

import 'package:mlkit_test/api/models/id_detect.dart';

// import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mlkit_test/api/models/id_is_real_score.dart';
import 'package:mlkit_test/api/models/id_text.dart';

class ApiServiceId {
  static const String baseUrl = "https://devsslgpu.cubox-apis.com:8000";
  static const String detect = "/v1/detect";
  static const String isRealScore = "/v1/is_real/score";
  static const String isText = "/v1/text";

  static Future<IdDetectModel> getIdDetect(String path) async {
    final url = Uri.parse('$baseUrl$detect');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath(
        'img',
        path,
      ));
    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      print("getIdDetect body $body");
      final Map<String, dynamic> detect = json.decode(body);
      return IdDetectModel.fromJson(detect);
    } else {
      final body = await response.stream.bytesToString();
      print("getIdDetect error body $body");
    }
    throw Error();
  }

  static Future<IdIsRealScore> getIdRealScore(String path) async {
    final url = Uri.parse('$baseUrl$isRealScore');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath(
        'img',
        path,
      ));
    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      print("getIdRealScore body $body");
      final Map<String, dynamic> score = json.decode(body);
      return IdIsRealScore.fromJson(score);
    } else {
      final body = await response.stream.bytesToString();
      print("getIdRealScore error body $body");
    }
    throw Error();
  }

  static Future<List<IdTextModel>> getIdText(String path) async {
    List<IdTextModel> textModels = [];
    final url = Uri.parse('$baseUrl$isText');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath(
        'img',
        path,
      ));
    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final models = json.decode(body);
      try {
        for (var model in models) {
          textModels.add(IdTextModel.fromJson(model));
        }
      } catch (e) {
        print("getIdText error $e");
      }

      return textModels;
    } else {
      final body = await response.stream.bytesToString();
      print("getIdRealScore error body $body");
    }
    throw Error();
  }
}
