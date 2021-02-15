import 'package:workerf/model/index.dart';

class PackageRepository{
  List<PackageModel> packages;

  PackageRepository(this.packages);

  factory PackageRepository.fromList(List<dynamic> packages){
    List<PackageModel> _packages = [];
    packages.forEach((package) {
      _packages.add(PackageModel.fromMap(package));
    });

    return PackageRepository(_packages);
  }
}