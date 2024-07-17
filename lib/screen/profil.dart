import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/helper/dialogo.dart';
import 'package:whats_app/core/utils/routes.dart';
import 'package:whats_app/main.dart';
import 'package:whats_app/models/chat_user_model.dart';

class Profil extends StatefulWidget {
  const Profil({
    super.key,
    this.user,
  });
  final ChatUserModel? user;
  @override
  State<Profil> createState() => _ProfilState();
}

final formKey = GlobalKey<FormState>();

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      // onTap: () => Focus.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profile'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((valu) async {
                await GoogleSignIn().signOut().then((valu) {
                  GoRouter.of(context).push(kLoginhView);
                });
              });
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .5),
                        child: Image.network(
                          height: mq.height * .2,
                          width: mq.height * .2,
                          fit: BoxFit.fill,
                          Apis.user.photoURL.toString(),
                          // scale: .5,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {},
                          color: Colors.white,
                          shape: const CircleBorder(),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),

                  // adding spase

                  SizedBox(height: mq.height * .03),

                  Text(widget.user!.name),

                  // adding spase
                  SizedBox(height: mq.height * .03),

                  TextFormField(
                    onSaved: (newValue) {
                      Apis.me.name = newValue ?? "";
                    },
                    validator: (value) {
                      return value != null && value.isNotEmpty
                          ? null
                          : "Name is required";
                    },
                    initialValue: Apis.me.name,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: "hi",
                      label: const Text("Name"),
                    ),
                  ),

                  // adding spase
                  SizedBox(height: mq.height * .02),

                  TextFormField(
                    onSaved: (newValue) {
                      Apis.me.about = newValue ?? "";
                    },
                    validator: (value) {
                      return value != null && value.isNotEmpty
                          ? null
                          : "Name is required";
                    },
                    initialValue: Apis.me.about,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: "hi",
                      label: const Text("about"),
                    ),
                  ),
                  SizedBox(height: mq.height * .02),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        Apis.updateUserInfo().then((valu) {
                          Dialogo.showSnackBar(context, "Updated Sucessfuly");
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, size: 28),
                    style: ElevatedButton.styleFrom(
                        // backgroundColor: Colors.blue,
                        shape: const StadiumBorder(),
                        maximumSize: Size(mq.width * .5, mq.height * .06)),
                    label: const Text("Update", style: TextStyle(fontSize: 16)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileTextFormField extends StatelessWidget {
  const ProfileTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (newValue) {
        Apis.me.name = newValue ?? "";
      },
      validator: (value) {
        return value != null && value.isNotEmpty ? null : "Name is required";
      },
      initialValue: Apis.user.displayName,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.blue,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: "hi",
        label: const Text("Name"),
      ),
    );
  }
}
