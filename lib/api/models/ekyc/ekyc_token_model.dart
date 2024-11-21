class EKYCTokenModel {
  final String token;

  EKYCTokenModel.fromJson(Map<String, dynamic> json)
      : token = json['data']['token'];
}
