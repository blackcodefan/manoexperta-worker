import 'package:workerf/model/index.dart';

class PackageState{
  dynamic error;
  bool loading;
  List<PackageModel> packages;

  PackageState({this.error, this.packages, this.loading});

  factory PackageState.init() => PackageState(
      loading: false,
      packages: []
  );
}