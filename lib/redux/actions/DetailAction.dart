import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:workerf/redux/state/index.dart';
import 'ActionGenerator.dart';
import 'ActionTypes.dart';

getDetailAction(String token, int reqId){

  BackendActionGenerator generator = BackendActionGenerator(
      method: 'GET',
      endpoint: 'https://back.manoexperta.com/rest/detail/$token/$reqId',
      types: [
        ActionTypes.fetchDetail1,
        ActionTypes.fetchDetail2,
        ActionTypes.fetchDetail3,
      ]
  );

  return generator.generate();
}

finishAction(String token, int reqId, LatLng location, String finishCode){
  BackendActionGenerator generator = BackendActionGenerator(
      method: 'PUT',
      endpoint: 'https://back.manoexperta.com/rest/requests/$token',
      types: [
        ActionTypes.finishProject1,
        ActionTypes.finishProject2,
        ActionTypes.finishProject3,
      ],
    body: {
      "reqid": reqId,
      "latlng": "${location.latitude},${location.longitude}",
      "action": "worker_finish",
      "workerfinishcode": finishCode
    }
  );

  return generator.generate();
}

ThunkAction<AppState> getDetail(String token, int reqId) => (Store<AppState> store) => store.dispatch(getDetailAction(token, reqId));
ThunkAction<AppState> finishDetail(String token, int reqId, LatLng location, String finishCode) => (Store<AppState> store) => store.dispatch(finishAction(token, reqId, location, finishCode));