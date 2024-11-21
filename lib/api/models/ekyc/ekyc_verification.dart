import 'package:mlkit_test/api/models/common_ekyc_model.dart';

class EKYCVerification {
  final double score, threshold;
  final CommonEkycModel common;

  EKYCVerification.fromJson(Map<String, dynamic> json)
      : score = json['data']['score'],
        threshold = json['data']['threshold'],
        common = CommonEkycModel.fromJson(json);
}
