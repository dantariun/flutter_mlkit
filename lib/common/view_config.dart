import 'package:shared_preferences/shared_preferences.dart';

class ViewConfigRepository {
  static const String _token = "token";
  static const String _viewMode = "viewMode";
  static const String _idType = "idType";
  static const String _idPath = "idPath";
  static const String _realType = "realType";
  static const String _resultBool = "resultBool";

  final SharedPreferences _preferences;

  ViewConfigRepository(
    this._preferences,
  );

  Future<void> setToken(String token) async {
    _preferences.setString(_token, token);
  }

  Future<void> setViewMode(ViewMode viewMode) async {
    _preferences.setString(_viewMode, viewMode.code);
  }

  Future<void> setIdType(IdType idType) async {
    _preferences.setString(_idType, idType.code);
  }

  Future<void> setIdPath(String path) async {
    _preferences.setString(_idPath, path);
  }

  Future<void> setRealPath(String path) async {
    _preferences.setString(_realType, path);
  }

  Future<void> setResultBool(bool result) async {
    _preferences.setBool(_resultBool, result);
  }

  String getToken() {
    return _preferences.getString(_token) ?? "";
  }

  ViewMode isViewMode() {
    final code = _preferences.getString(_viewMode) ?? "etc";
    return ViewMode.getByCode(code);
  }

  IdType isIdtype() {
    final code = _preferences.getString(_idType) ?? "etc";
    return IdType.getByCode(code);
  }

  String isIdPath() {
    return _preferences.getString(_idPath) ?? "";
  }

  String isRealPath() {
    return _preferences.getString(_realType) ?? "";
  }

  bool isResultBool() {
    return _preferences.getBool(_resultBool) ?? false;
  }
}

class ViewConfigModel {
  String token;
  String viewMode;
  String idType;
  String idPath;
  String realPath;
  bool resultBool;

  ViewConfigModel({
    required this.token,
    required this.viewMode,
    required this.idType,
    required this.idPath,
    required this.realPath,
    required this.resultBool,
  });
}

enum ViewMode {
  identity('identity'),
  ocr('ocr'),
  matching('matching'),
  liveness('liveness'),
  full('full'),
  etc('etc');

  const ViewMode(this.code);
  final String code;

  factory ViewMode.getByCode(String code) {
    return ViewMode.values.firstWhere((value) => value.code == code);
  }
}

enum IdType {
  national('National ID Number'),
  driver('Driving License'),
  passport('Passport Number'),
  etc('etc');

  const IdType(this.code);
  final String code;

  factory IdType.getByCode(String code) {
    return IdType.values.firstWhere((element) => element.code == code);
  }
}

enum Authenticity {
  original('Original'),
  replica('Replica');

  const Authenticity(this.code);
  final String code;

  factory Authenticity.getByCode(String code) {
    return Authenticity.values.firstWhere((element) => element.code == code);
  }
}
