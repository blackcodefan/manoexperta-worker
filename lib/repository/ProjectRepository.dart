import 'package:workerf/model/index.dart';

class ProjectRepository{
  List<ProjectModel> projects;

  ProjectRepository(this.projects);

  void deleteById(int id){
    projects.removeWhere((element) => element.id == id);
  }

  void add(ProjectModel project){
    projects.insert(0, project);
  }

  List<ProjectModel> filter(UserModel user){
    List<ProjectModel> _projects = [];
    projects.forEach((ProjectModel project) {
      project.calcDistance(user.location);
      if(project.distance <= user.range
          && user.categories.indexOf(project.catId) != -1
          && (project.exclusive == 0 || project.exclusive == user.source)
          && project.blocked.indexOf(user.userId) == -1){
        _projects.add(project);
      }
    });

    return _projects;
  }

  factory ProjectRepository.fromList(List<dynamic> projects){
    List<ProjectModel> _projects = [];
    projects.forEach((project) {
      _projects.add(ProjectModel.fromMap(project));
    });

    return ProjectRepository(_projects);
  }
}