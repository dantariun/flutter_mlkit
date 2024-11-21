import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mlkit_test/common/view_config.dart';

class ViewConfigViewModel extends Notifier<ViewConfigModel> {
  final ViewConfigRepository _repository;

  ViewConfigViewModel(this._repository);

  void setToken(String token) {
    _repository.setToken(token);
    state = ViewConfigModel(
      token: token,
      viewMode: state.viewMode,
      idType: state.idType,
      idPath: state.idPath,
      realPath: state.realPath,
      resultBool: state.resultBool,
    );
  }

  void setViewMode(ViewMode value) {
    _repository.setViewMode(value);
    state = ViewConfigModel(
      token: state.token,
      viewMode: value.code,
      idType: state.idType,
      idPath: state.idPath,
      realPath: state.realPath,
      resultBool: state.resultBool,
    );
  }

  void setIdType(IdType value) {
    _repository.setIdType(value);
    state = ViewConfigModel(
      token: state.token,
      viewMode: state.viewMode,
      idType: value.code,
      idPath: state.idPath,
      realPath: state.realPath,
      resultBool: state.resultBool,
    );
  }

  void setIdPath(String path) {
    _repository.setIdPath(path);
    state = ViewConfigModel(
      token: state.token,
      viewMode: state.viewMode,
      idType: state.idPath,
      idPath: path,
      realPath: state.realPath,
      resultBool: state.resultBool,
    );
  }

  void setRealPath(String path) {
    _repository.setRealPath(path);
    state = ViewConfigModel(
      token: state.token,
      viewMode: state.viewMode,
      idType: state.idPath,
      idPath: state.idPath,
      realPath: path,
      resultBool: state.resultBool,
    );
  }

  void setLivenessResult(bool result) {
    _repository.setResultBool(result);
    state = ViewConfigModel(
      token: state.token,
      viewMode: state.viewMode,
      idType: state.idPath,
      idPath: state.idPath,
      realPath: state.realPath,
      resultBool: result,
    );
  }

  @override
  ViewConfigModel build() {
    return ViewConfigModel(
      token: _repository.getToken(),
      idType: _repository.isIdtype().code,
      viewMode: _repository.isViewMode().code,
      idPath: _repository.isIdPath(),
      realPath: _repository.isRealPath(),
      resultBool: _repository.isResultBool(),
    );
  }
}

final viewConfigProvider =
    NotifierProvider<ViewConfigViewModel, ViewConfigModel>(
  () => throw UnimplementedError(),
);
