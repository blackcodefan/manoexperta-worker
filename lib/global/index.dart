library global;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:workerf/model/index.dart';
import 'package:workerf/provider/index.dart';
import 'package:redux/redux.dart';
import 'package:workerf/redux/index.dart';
import 'package:redux_api_middleware/redux_api_middleware.dart';
import 'package:redux_thunk/redux_thunk.dart';

final String appId = "1";
final String appSecret = "oficiosme\$";

final String authKey = 'AIzaSyDoDiLbcH17tCdEsLkPZk-KHmbrZs8qTa0';

final String googleMapApiKey = 'AIzaSyBFdPu1NW8VNvNo5WVaC6tZ5NgCxkOUiRo';
final String googleMapApiBrowserKey = 'AIzaSyAIpDU6KQfi7hp56o39G2jp2aPcv6lSW5w';

final String notificationAuthKey = 'key=AAAAjrL3RqA:APA91bF4mDJnoUrHKoE0WefkJs5eYPco5H5rq4RSIw0KNs9X-djDq5oA4zlahdevGvVY_IOlgp1bjqGrzQk1NRH0POr6v87krG7P2EJfDMUlaeUwsCPd8vevjCQGNwfS7KD-iuqbMk-H';

final GlobalKey<NavigatorState> navigationKey = GlobalKey();

String notificationToken;

UserModel currentUser;

MarketConfigModel globalMarket;

Position globalLocationData;

ExternalSocket eSocket = ExternalSocket();

InternalSocket iSocket = InternalSocket();

final store = Store<AppState>(
  appReducer,
  initialState: AppState.init(),
  middleware: [thunkMiddleware, apiMiddleware],
);