import 'package:flutter/material.dart';
import 'stub.dart';

/// Renders a SIGN IN button that calls `handleSignIn` onclick.
Widget buildSignInButton({HandleSignInFn? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: const Text(
      'INICIAR SESIÓN',
      style: TextStyle(color: Colors.green), // Set text color to white
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set background color to green
    ),
  );
}