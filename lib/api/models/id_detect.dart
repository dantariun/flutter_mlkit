class IdDetectModel {
  final double conf;
  final int cls;
  final List<dynamic> bbox;

  IdDetectModel.fromJson(Map<String, dynamic> json)
      : bbox = json['bbox'],
        conf = json['conf'],
        cls = json['cls'];
}

/*
{
  "bbox": [
    5,
    320,
    709,
    758
  ],
  "conf": 0.970039963722229,
  "cls": 1
}
*/
