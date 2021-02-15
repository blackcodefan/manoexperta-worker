import 'package:workerf/repository/index.dart';

class ProjectState{
  dynamic error;
  bool loading;
  ProjectRepository repository;

  ProjectState({this.error, this.repository, this.loading});

  factory ProjectState.init() => ProjectState(
      loading: false,
      repository: ProjectRepository([])
  );
}