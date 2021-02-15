import 'package:workerf/model/index.dart';

class PProjectState{
  dynamic error;
  bool loading;
  List<PProjectModel> projects;

  PProjectState({this.error, this.projects, this.loading});

  factory PProjectState.init() => PProjectState(
      loading: false,
      projects: []
  );
}