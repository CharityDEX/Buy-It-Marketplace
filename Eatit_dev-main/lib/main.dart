import 'package:eatit_dev/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:eatit_dev/shared/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: Constants.apiKey, appId: Constants.appId, messagingSenderId: Constants.messagingSenderId, projectId: Constants.projectId, storageBucket: Constants.storageBucket));
  }
  else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Satoshi'),
      home: const HomePage(),
    );
  }
}
