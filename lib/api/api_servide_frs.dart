import 'package:mlkit_test/api/models/frs_verification_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServiceFrs {
  static const String baseUrl = "https://frs-ovms-dev.cuboxservice.com:5000";
  static const String verificationImageForm = "/v1/verification/image-form";

  static Future<FrsVerificationImage> verificationImage(
    String idPath,
    String realPath,
  ) async {
    final url = Uri.parse('$baseUrl$verificationImageForm');
    final request = http.MultipartRequest('POST', url)
      ..files.add(
        await http.MultipartFile.fromPath(
          'image1',
          idPath,
        ),
      )
      ..files.add(
        await http.MultipartFile.fromPath(
          'image2',
          realPath,
        ),
      )
      ..headers.addAll(
        {
          "X-Api-Key": "CUFRSDEV-A01B-C23D-45EF-6G7H89I0123J",
        },
      );
    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final Map<String, dynamic> data = json.decode(body);
      return FrsVerificationImage.fromJson(data);
    } else {
      final errorBody = await response.stream.bytesToString();
      print("verificationImage error body $errorBody");
    }
    throw Error();
  }
}
