import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/utils/firebase_functions.dart';
import 'package:whats_app/core/utils/routes.dart';
import 'package:whats_app/core/helper/dialogo.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isAnimated = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome to chat"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            top: mq.height * 0.15,
            right: _isAnimated ? mq.width * 0.25 : -mq.width * 0.5,
            width: mq.width * 0.5,
            child: Image.asset("assets/images/icon.png"),
          ),
          Positioned(
              bottom: mq.height * 0.15,
              left: mq.width * 0.05,
              width: mq.width * 0.9,
              height: mq.height * 0.07,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      elevation: 1,
                      shape: const StadiumBorder()),
                  onPressed: () async {
                    try {
                      await FirebaseFunctions().signInWithGoogle();

                      await FirebaseFunctions().handelSignInGoogle();
                      if ((await Apis.usersExists())) {
                        GoRouter.of(context).push(kHome);
                      } else {
                        await Apis.createUser().then((valu) {
                          GoRouter.of(context).push(kHome);
                        });
                      }
                      GoRouter.of(context).push(kHome);
                    } on Exception catch (e) {
                      log("signInWithGoogle : $e");
                      Dialogo.showSnackBar(context, "internt not connection");
                    }
                  },
                  label: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: [
                        TextSpan(text: "Login with "),
                        TextSpan(
                          text: "Google",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ])),
                  icon: Image.asset(
                    "assets/images/google.png",
                    height: mq.height * .06,
                  )))
        ],
      ),
    );
  }
}
