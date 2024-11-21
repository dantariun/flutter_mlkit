class CommonEkycModel {
  final String message;
  final String timestamp;
  final String type;
  final String title;
  final String detail;
  final String instance;
  final int status;

  CommonEkycModel.fromJson(Map<String, dynamic> json)
      : timestamp = json["timestamp"] ?? "",
        message = json["message"] ?? "",
        type = json["type"] ?? "",
        title = json["title"] ?? "",
        detail = json["detail"] ?? "",
        instance = json["instance"] ?? "",
        status = json["status"] ?? 0;
}
