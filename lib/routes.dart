import 'package:flutter/material.dart';
import 'package:workerf/ui/APayment/index.dart';
import 'package:workerf/ui/InqConversation/index.dart';
import 'package:workerf/ui/PMarket/index.dart';
import 'package:workerf/ui/Splash/index.dart';
import 'package:workerf/ui/ChooseLogin/index.dart';
import 'package:workerf/ui/Login/index.dart';
import 'package:workerf/ui/Register/index.dart';
import 'package:workerf/ui/Map/index.dart';
import 'package:workerf/ui/Projects/index.dart';
import 'package:workerf/ui/Progress/index.dart';
import 'package:workerf/ui/Support/index.dart';
import 'package:workerf/ui/TAC/index.dart';
import 'package:workerf/ui/Terminate/index.dart';
import 'package:workerf/ui/Category/index.dart';
import 'package:workerf/ui/PCategory/index.dart';
import 'package:workerf/ui/Profile/index.dart';
import 'package:workerf/ui/RFriend/index.dart';
import 'package:workerf/ui/RecoverPwd/index.dart';
import 'package:workerf/ui/Payments/index.dart';
import 'package:workerf/ui/ImageViewer/index.dart';
import 'package:workerf/ui/PProjects/index.dart';
import 'package:workerf/ui/Identification/index.dart';
import 'package:workerf/ui/Conversation/index.dart';
import 'package:workerf/ui/Conversation/LocationPicker.dart';
import 'package:workerf/ui/Inquiries/index.dart';
import 'package:workerf/ui/HConversation/index.dart';
import 'package:workerf/ui/Market/index.dart';
import 'package:workerf/ui/Premium/index.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:workerf/global/index.dart';

class Routes
{
  static Route<dynamic> generateRoute(RouteSettings settings)
  {
    final args = settings.arguments;
    switch(settings.name)
    {
      case '/splash':
        return MaterialPageRoute(builder: (_) => Splash());
      case '/choose':
        return MaterialPageRoute(builder: (_) => ChooseLogin());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/register':
        return MaterialPageRoute(builder: (_) => Register());
      case '/map':
        return MaterialPageRoute(builder: (_) => MapScreen());
      case '/projects':
        return MaterialPageRoute(builder: (_) => Projects());
      case '/terminate':
        return MaterialPageRoute(builder: (_) => Terminate());
      case '/progress':
        return MaterialPageRoute(builder: (_) => Progress());
      case '/category':
        return MaterialPageRoute(builder: (_) => Category());
      case '/pCategory':
        return MaterialPageRoute(builder: (_) => PCategory());
      case '/support':
        return MaterialPageRoute(builder: (_) => Support());
      case '/tac':
        return MaterialPageRoute(builder: (_) => TAC(args));
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());
      case '/friend':
        return MaterialPageRoute(builder: (_) => RFriend(args));
      case '/recoverPwd':
        return MaterialPageRoute(builder: (_) => RecoverPwd());
      case '/aPayment':
        return MaterialPageRoute(builder: (_) => APayment());
      case '/payments':
        return MaterialPageRoute(builder: (_) => Payments());
      case '/imageViewer':
        return MaterialPageRoute(builder: (_) => ImageViewer(args));
      case '/pProjects':
        return MaterialPageRoute(builder: (_) => PProjects());
      case '/identification':
        return MaterialPageRoute(builder: (_) => Identification());
      case '/conversation':
        return MaterialPageRoute(builder: (_) => Conversation(args));
      case '/locationPicker':
        return MaterialPageRoute(builder: (_) => LocationPicker());
      case '/inquiry':
        return MaterialPageRoute(builder: (_) => Inquiry());
      case '/inqConversation':
        return MaterialPageRoute(builder: (_) => InqConversation(model: args));
      case '/hConversation':
        return MaterialPageRoute(builder: (_) => HConversation(args));
      case '/market':
        return MaterialPageRoute(builder: (_) => Market());
      case '/pMarket':
        return MaterialPageRoute(builder: (_) => PMarket());
      case '/premium':
        return MaterialPageRoute(builder: (_) => Premium());
      default:
        return MaterialPageRoute(builder: (_) => Splash());
    }
  }

  Routes()
  {

    runApp(StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Soy Experto',
        home: Splash(),
        theme: ThemeData(
            hintColor: Colors.white,
            primarySwatch: Colors.blue),
        navigatorKey: navigationKey,
        onGenerateRoute: generateRoute
      ),
    ));
  }
}