import 'dart:io';

import 'package:flutter_web_auth/flutter_web_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const html = """
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Grant Access to Flutter</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    html, body { margin: 0; padding: 0; }

    main {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica,Arial,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol;
    }

    #icon {
      font-size: 96pt;
    }

    #text {
      padding: 2em;
      max-width: 260px;
      text-align: center;
    }

    #button a {
      display: inline-block;
      padding: 6px 12px;
      color: white;
      border: 1px solid rgba(27,31,35,.2);
      border-radius: 3px;
      background-image: linear-gradient(-180deg, #34d058 0%, #22863a 90%);
      text-decoration: none;
      font-size: 14px;
      font-weight: 600;
    }

    #button a:active {
      background-color: #279f43;
      background-image: none;
    }
  </style>
</head>
<body>
  <main>
    <div id="icon">&#x1F3C7;</div>
    <div id="text">Press the button below to sign in using your Localhost account.</div>
    <div id="button"><a href="localtest:34352/auth.html?code=1234">Sign in</a></div>
  </main>
</body>
</html>
""";

class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  String _status = '';

  @override
  void initState() {
    super.initState();
    //this won´t work on flutter web because it can only monitor one
    //address at a time, so we have to test whether we're on the web
    if (!kIsWeb) {
      startServer();
    }
  }

  Future<void> startServer() async {
    final server = await HttpServer.bind('127.0.0.1', 34352);

    server.listen((req) async {
      setState(() {
        _status = 'Received request!';
      });

      req.response.headers.add('Content-Type', 'text/html');
      req.response.write(html);
      req.response.close();
    });
  }

  void authenticate() async {
    late String url;
    if (kIsWeb) {
      url = 'http://localhost:34352/auth.html?code=1234';
    } else {
      url = 'http://localtest:34352/';
    }
    final callbackUrlScheme = 'foobar';

    try {
      final result = await FlutterWebAuth.authenticate(
          url: url, callbackUrlScheme: callbackUrlScheme);
      setState(() {
        _status = 'Got result: $result';
      });
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Got error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Web Auth example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Status: $_status\n'),
              const SizedBox(height: 80),
              ElevatedButton(
                child: Text('Authenticate'),
                onPressed: () {
                  this.authenticate();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
