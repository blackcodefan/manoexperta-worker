import 'package:workerf/model/index.dart';

class DetailState{
  dynamic error;
  bool loading;
  ProjectDetailModel detail;

  DetailState({this.error, this.detail, this.loading});

  factory DetailState.init() => DetailState(
      loading: false,
      detail: ProjectDetailModel.init()
  );
}