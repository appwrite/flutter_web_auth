import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io' show HttpServer;

import 'package:flutter_web_auth_example/authentication_page.dart';
import 'package:flutter_web_auth_example/home_page.dart';
import 'package:flutter_web_auth_example/unknown_page.dart';

void main() {
  runApp(
    MaterialApp(
      onGenerateRoute: (settings) {
        print(settings.name);
        late Widget widget;
        switch (settings.name) {
          case '/':
            widget = HomePage();
            break;
          case '/authentication_page':
            widget = AuthenticationPage();
            break;
          default:
            widget = UnknownPage();
        }
        ;

        return MaterialPageRoute(
          builder: (context) => widget,
        );
      },
    ),
  );
}
