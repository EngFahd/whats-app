import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/utils/routes.dart';
import 'package:whats_app/screen/login.dart';
import 'package:whats_app/screen/home.dart';
import 'package:whats_app/screen/splash_view.dart';
import 'package:whats_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const WhatsApp());
}

var  mq ;

class WhatsApp extends StatelessWidget {
  const WhatsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouters.routes,
    );
  }
}
