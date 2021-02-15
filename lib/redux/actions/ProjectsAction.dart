import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:workerf/global/index.dart';
import 'package:workerf/redux/state/index.dart';
import 'package:workerf/repository/index.dart';
import 'ActionGenerator.dart';
import 'ActionTypes.dart';

getProjectsAction(String token, LatLng position){

  BackendActionGenerator generator = BackendActionGenerator(
      method: 'GET',
      endpoint: 'https://back.manoexperta.com/rest/requests/$token/${position.latitude},${position.longitude}',
      types: [
        ActionTypes.fetchProjects1,
        ActionTypes.fetchProjects2,
        ActionTypes.fetchProjects3,
      ]
  );

  return generator.generate();
}

applyProjectAction(String token, int reqId){
  BackendActionGenerator generator = BackendActionGenerator(
      method: 'PUT',
      endpoint: 'https://back.manoexperta.com/rest/requests/$token',
      types: [
        ActionTypes.applyProject1,
        ActionTypes.applyProject2,
        ActionTypes.applyProject3,
      ],
    body: {
      "reqid": reqId,
      "latlng": '${globalLocationData.latitude},${globalLocationData.longitude}',
      "action": "worker_apply"
    }
  );

  return generator.generate();
}

declineProjectAction(String token, int reqId){
  BackendActionGenerator generator = BackendActionGenerator(
      method: 'PUT',
      endpoint: 'https://back.manoexperta.com/rest/requests/$token',
      types: [
        ActionTypes.declineProject1,
        ActionTypes.declineProject2,
        ActionTypes.declineProject3,
      ],
      body: {
        "reqid": reqId,
        "latlng": '${globalLocationData.latitude},${globalLocationData.longitude}',
        "action": "worker_reject"
      }
  );

  return generator.generate();
}

updateProjectsAction(ProjectRepository repository){
  return ProjectsUpdateActionGenerator(ActionTypes.updateProjects, repository).generate();
}

ThunkAction<AppState> getProjects(String token, LatLng position) => (Store<AppState> store) => store.dispatch(getProjectsAction(token, position));
ThunkAction<AppState> applyProject(String token, int reqId) => (Store<AppState> store) => store.dispatch(applyProjectAction(token, reqId));
ThunkAction<AppState> declineProject(String token, int reqId) => (Store<AppState> store) => store.dispatch(declineProjectAction(token, reqId));
ThunkAction<AppState> updateProjects(ProjectRepository repository) => (Store<AppState> store) => store.dispatch(updateProjectsAction(repository));