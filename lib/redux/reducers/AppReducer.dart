import 'package:workerf/redux/index.dart';
import 'package:workerf/redux/reducers/CategoryReducer.dart';
import 'package:workerf/redux/state/index.dart';
import 'AuthReducer.dart';
import 'CredentialReducer.dart';
import 'HintReducer.dart';
import 'PProjectReducer.dart';
import 'ProjectReducer.dart';
import 'MarketReducer.dart';

AppState appReducer(AppState state, action){

  return AppState(
      credentialState: credentialReducer(state.credentialState, action),
      authState: authReducer(state.authState, action),
      hintState: hintReducer(state.hintState, action),
      categoryState: categoryReducer(state.categoryState, action),
      pProjectState: pProjectReducer(state.pProjectState, action),
      projectState: projectReducer(state.projectState, action),
      detailState: detailReducer(state.detailState, action),
      bidState: bidReducer(state.bidState, action),
      marketState: marketReducer(state.marketState, action)
  );
}