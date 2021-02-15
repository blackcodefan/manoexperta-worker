import 'package:workerf/model/index.dart';

class PProjectRepository{
  List<PProjectModel> projects;

  PProjectRepository(this.projects);

  factory PProjectRepository.fromList(List<dynamic> pprojects){
    List<PProjectModel> _projects = [];
    pprojects.forEach((element) {
      _projects.add(PProjectModel.fromMap(element));
    });

    return PProjectRepository(_projects);
  }
}