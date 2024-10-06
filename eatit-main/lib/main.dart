import 'package:eatit/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:eatit/shared/constants.dart';
import 'package:meta_seo/meta_seo.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: Constants.apiKey, appId: Constants.appId, messagingSenderId: Constants.messagingSenderId, projectId: Constants.projectId, storageBucket: Constants.storageBucket));
    MetaSEO().config();
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

    if(kIsWeb){
    MetaSEO meta = MetaSEO();
    meta.author(author: 'Yugal Pande');
    meta.description(description: 'Buy It Market is an innovative online marketplace that connects consumers with local artisans and sustainable businesses, offering a curated selection of unique and eco-friendly products to promote community engagement and environmental responsibility');
    meta.keywords(keywords: 'Buyit, Marketplace, Sustainable, Cheap, Affordable');
    meta.ogTitle(ogTitle: "Buy It Marketplace");
    meta.ogDescription(ogDescription: 'Buy It Market is an innovative online marketplace that connects consumers with local artisans and sustainable businesses, offering a curated selection of unique and eco-friendly products to promote community engagement and environmental responsibility');
    }

    return MaterialApp(
      title: "Buy It Marketplace",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Satoshi'),
      home: const HomePage(),
    );
  }
}
