import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/user.dart' as userModel;

import 'package:restaurant/service/authService.dart';
import 'package:restaurant/wapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAGcqTGdnpbp4vZFmiH5K95RU6lAdlA7QM",
      projectId: "fluttermain-2dd00",
      appId: "1:575340225748:android:e8f5b3525eae057cfe8741",
      messagingSenderId: '',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().user
          as Stream<User?>?, // Explicitly cast to match the type
      child: MaterialApp(
        home: wapper(),
      ),
    );
  }
}
