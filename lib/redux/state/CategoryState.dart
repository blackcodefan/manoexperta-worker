import 'package:workerf/repository/index.dart';

class CategoryState{
  dynamic error;
  bool loading;
  CategoryRepository repository;



  CategoryState({this.error, this.repository, this.loading});

  factory CategoryState.init() => CategoryState(
      loading: false,
    repository: CategoryRepository([])
  );
}