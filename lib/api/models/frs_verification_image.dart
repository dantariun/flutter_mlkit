class FrsVerificationImage {
  final double score, threshold;
  final String errorCode, errorResponse;
  final int timestamp;

  FrsVerificationImage.fromJson(Map<String, dynamic> json)
      : score = json['data']['score'],
        threshold = json['data']['threshold'],
        errorCode = json['errorCode'],
        errorResponse = json['errorResponse'],
        timestamp = json['timestamp'];
}

/*
{
  "data": {
    "score": 0,
    "threshold": 0
  },
  "timestamp": 0,
  "errorCode": "string",
  "errorResponse": "string"
}
*/
