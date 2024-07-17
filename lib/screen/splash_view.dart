import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:whats_app/core/utils/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        // if (FirebaseAuth.instance.currentUser != null) {
        //   log("\nUser : ${FirebaseAuth.instance.currentUser}");
        //   GoRouter.of(context).push(kChat);
        // } else {
        // }
          GoRouter.of(context).push(kLoginhView);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/animations/splash_view.json"),
      ),
    );
  }
}
