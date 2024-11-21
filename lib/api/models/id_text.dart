class IdTextModel {
  final String text, type;
  final dynamic bbox; // not used

  IdTextModel.fromJson(Map<String, dynamic> json)
      : bbox = json['bboxes'],
        text = json['text'],
        type = json['type'];
}

/*
[
  {
    "text": "홍길동",
    "bbox": [
      [
        1,
        2
      ],
      [
        11,
        22
      ],
      [
        33,
        44
      ],
      [
        3,
        4
      ]
    ],
    "type": "name"
  }
]
*/
