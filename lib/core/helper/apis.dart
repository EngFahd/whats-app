import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app/core/utils/constant.dart';
import 'package:whats_app/models/chat_user_model.dart';

class Apis {
  // for auth
  static FirebaseAuth auth = FirebaseAuth.instance;

// for firesstore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //get user
  static User get user => auth.currentUser!;

  // get my profile
  static late ChatUserModel me;

  // users exists
  static Future<bool> usersExists() async {
    return (await firestore
            .collection(FireStoreConstant.collectionNameUsers)
            .doc(user.uid)
            .get())
        .exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore
        .collection(FireStoreConstant.collectionNameUsers)
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUserModel.fromJson(user.data()!);
      } else {
        await createUser().then((valu) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(
        id: user.uid,
        isOnline: true,
        pushToken: "",
        createdAt: time,
        image: user.photoURL.toString(),
        about: "i am using my chat",
        lastActive: time,
        name: user.displayName.toString());

    return firestore
        .collection(FireStoreConstant.collectionNameUsers)
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection(FireStoreConstant.collectionNameUsers)
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  static updateUserInfo() async {
    await firestore
        .collection(FireStoreConstant.collectionNameUsers)
        .doc(user.uid)
        .update(({
          'name': me.name,
          'about': me.about,
          // 'image' : me.image,
        }));
  }
}
