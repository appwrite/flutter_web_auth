import 'package:flutter/material.dart';

import 'dart:html' as html;

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Web Auth example'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Verify authenticity'),
            onPressed: () {
              html.window.open('localhost:34352/auth.html?code=1234',"_self");

              
            },
          ),
        ),
      );
  }
}