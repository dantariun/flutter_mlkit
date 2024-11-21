import 'package:mlkit_test/api/models/common_ekyc_model.dart';
import 'package:mlkit_test/api/models/id_detect.dart';

class EKYCReal {
  final IdDetectModel detectModel;
  final String isReal;
  final double score, threshold;
  final CommonEkycModel common;

  EKYCReal.fromJson(Map<String, dynamic> json)
      : common = CommonEkycModel.fromJson(json),
        detectModel = IdDetectModel.fromJson(json["data"]["detect"]),
        isReal = json["data"]["isReal"] ?? "",
        score = json["data"]['score'] ?? 0.0,
        threshold = json["data"]['threshold'] ?? 0.0;
}
