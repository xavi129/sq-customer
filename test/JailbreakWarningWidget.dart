import 'package:flutter/material.dart';

class JailbreakWarningWidget extends StatelessWidget {

  const JailbreakWarningWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
           'El modo desarrollador está activado. Por favor, desactívalo.', style: TextStyle(fontSize: 18, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}