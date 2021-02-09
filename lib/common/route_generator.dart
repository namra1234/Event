import '../views/addeditEvent.dart';
import 'package:flutter/material.dart';

import '../views/eventMainPage.dart';


const String EventMain = 'EventMainPage';
const String AddEditEventPage='AddEditEvent';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments as Map<String,dynamic>;
    Widget page;
    switch (settings.name) {
      case EventMain:
        page = EventMainPage();
        break;
      case AddEditEventPage:
        page = AddEditEvent(false,null);
        break;
      default:
        // If there is no such named route in the switch statement, e.g. /third
        page = EventMainPage();
        break;
    }
    return MaterialPageRoute(builder: (context) => page,);
  }
}
