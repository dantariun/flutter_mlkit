import 'package:mlkit_test/api/models/common_ekyc_model.dart';
import 'package:mlkit_test/api/models/ekyc/ekyc_ocr_text.dart';
import 'package:http/http.dart' as http;
import 'package:mlkit_test/api/models/ekyc/ekyc_real.dart';
import 'dart:convert';

import 'package:mlkit_test/api/models/ekyc/ekyc_token_model.dart';
import 'package:mlkit_test/api/models/ekyc/ekyc_verification.dart';
import 'package:mlkit_test/api/models/frs_verification_image.dart';
import 'package:mlkit_test/api/models/id_text.dart';

class ApiEkyc {
  static const String baseUrl = "http://54.180.38.96:8081";

  static const String verificationImage = "/api/v1/verification";
  static const String idOCR = "/api/v1/text";
  static const String idIReal = "/api/v1/real";
  static const String serverHealth = "/health";
  static const String token = "/common/token";

  static Future<EKYCVerification> ekycVerification(
      String idPath, String realPath, String token) async {
    final url = Uri.parse("$baseUrl$verificationImage");
    final request = http.MultipartRequest('POST', url)
      ..fields.addAll({
        "deviceType": "M",
        "userKey": "userKey",
        "userNm": "userNm",
        "userReqNum": "userReqNum",
      })
      ..files.add(
        await http.MultipartFile.fromPath('identityCard', idPath),
      )
      ..files.add(
        await http.MultipartFile.fromPath('image', realPath),
      )
      ..headers.addAll({
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final Map<String, dynamic> data = json.decode(body);

      print("ekycVerification verification body $body");
      return EKYCVerification.fromJson(data);
    } else {
      final errorBody = await response.stream.bytesToString();
      print("ekycVerification error body $errorBody");
    }
    throw Error();
  }

  static Future<EKYCOCRText> ekycOCRText(String idPath, String token) async {
    List<IdTextModel> textModels = [];

    final url = Uri.parse("$baseUrl$idOCR");
    final request = http.MultipartRequest('POST', url)
      ..fields.addAll({
        "deviceType": "M",
        "userKey": "userKey",
        "userNm": "userNm",
        "userReqNum": "userReqNum",
      })
      ..files.add(await http.MultipartFile.fromPath('identityCard', idPath))
      ..headers.addAll({
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final Map<String, dynamic> data = json.decode(body);
      for (var model in data["data"]["ocr"]) {
        textModels.add(IdTextModel.fromJson(model));
      }

      return EKYCOCRText.fromJson(data, textModels);
    } else {
      final errorBody = await response.stream.bytesToString();
      print("ekycOCRText error body $errorBody");
    }
    throw Error();
  }

  static Future<EKYCReal> getEKYCReal(String idPath, String token) async {
    final url = Uri.parse("$baseUrl$idIReal/P");
    final request = http.MultipartRequest('POST', url)
      ..fields.addAll({
        "deviceType": "M",
        "userKey": "userKey",
        "userNm": "userNm",
        "userReqNum": "userReqNum",
      })
      ..files.add(await http.MultipartFile.fromPath('identityCard', idPath))
      ..headers.addAll({
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      print("getEKYCReal Success:  body $body");
      final Map<String, dynamic> data = json.decode(body);

      return EKYCReal.fromJson(data);
    } else {
      final errorBody = await response.stream.bytesToString();
      print("getEKYCReal error body $errorBody");
    }

    throw Error();
  }

  static Future<EKYCTokenModel> ekycToken() async {
    final url = Uri.parse("$baseUrl$token");
    Map<String, String> data = {"siteCode": "Android"};
    final jsonBody = json.encode(data);
    final response = await http.post(
      url,
      body: jsonBody,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return EKYCTokenModel.fromJson(data);
    } else {
      final errorBody = response.body;
      print("ekycToken error body $errorBody");
    }

    throw Error();
  }
}
