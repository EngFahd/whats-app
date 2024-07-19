import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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

// form validations
final formKey = GlobalKey<FormState>();

// to save import image
String? _imageChose;

class _ProfilState extends State<Profil> {
  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              const Text(
                textAlign: TextAlign.center,
                "Pick profile pecture",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          log(image.path);
                          log(image.name);
                          setState(() {
                            _imageChose = image.path;
                          });
                          Apis.updateProfilePicture(File(_imageChose!))
                              .then((valu) {
                            Dialogo.showSnackBar(context, "Updated Sucessfuly");
                          });
                          GoRouter.of(context).pop();
                        }
                      },
                      child: Image.asset("assets/images/add_image.png"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log(image.path);
                          log(image.name);
                          setState(() {
                            _imageChose = image.path;
                          });
                          Apis.updateProfilePicture(File(_imageChose!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset("assets/images/camera.png"),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

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
                      _imageChose != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .5),
                              child: Image.file(
                                height: mq.height * .2,
                                width: mq.height * .2,
                                fit: BoxFit.cover,
                                File(_imageChose!),
                                // scale: .5,
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .5),
                              child: Image.network(
                                height: mq.height * .2,
                                width: mq.height * .2,
                                fit: BoxFit.cover,
                                Apis.user.photoURL.toString(),
                                // scale: .5,
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            showBottomSheet();
                          },
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
