import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager/data/repositories/password_reposistory.dart';
import 'package:password_manager/presentation/screens/password_manager_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final PasswordRepository passwordRepository = PasswordRepository(FlutterSecureStorage());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PasswordManagerScreen(passwordRepository),
    );
  }
}
