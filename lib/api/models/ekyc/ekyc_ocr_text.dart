import 'package:mlkit_test/api/models/common_ekyc_model.dart';
import 'package:mlkit_test/api/models/id_detect.dart';
import 'package:mlkit_test/api/models/id_text.dart';

class EKYCOCRText {
  final IdDetectModel detectModel;
  final List<IdTextModel> textModel;
  final CommonEkycModel common;

  EKYCOCRText.fromJson(Map<String, dynamic> json, List<IdTextModel> list)
      : common = CommonEkycModel.fromJson(json),
        detectModel = IdDetectModel.fromJson(json["data"]["detect"]),
        textModel = list;
}
