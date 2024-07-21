import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/utils/constant.dart';
import 'package:whats_app/core/utils/routes.dart';
import 'package:whats_app/main.dart';
import 'package:whats_app/models/chat_user_model.dart';
import 'package:whats_app/screen/profil.dart';
import 'package:whats_app/widgets/chat_list_view.dart';
import 'package:whats_app/widgets/chat_user_card.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });
  @override
  State<Home> createState() => _HomeState();
}

// store all user
List<ChatUserModel> _chatUserList = [];

// add user searcching
List<ChatUserModel> _searchList = [];
bool _isSearching = false;

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();
    Apis.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((massage) {
      log("$massage");
      if (Apis.auth.currentUser != null) {
  if (massage.toString().contains("paused")) Apis.updateActiveStatus(false);
  if (massage.toString().contains("resumed")) Apis.updateActiveStatus(true);
}

      return Future.value(massage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const Icon(CupertinoIcons.home),
          title: _isSearching
              ? TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Name, Email, ...."),
                  autofocus: true,
                  style: const TextStyle(fontSize: 17, letterSpacing: .5),
                  onChanged: (value) {
                    _searchList.clear();
                    for (var i in _chatUserList) {
                      if (i.name.toLowerCase().contains(value.toLowerCase())) {
                        _searchList.add(i);
                      }
                      setState(() {
                        _searchList;
                      });
                    }
                  },
                )
              : const Text('WhatsApp'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(_isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Profil(user: Apis.me);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.more_vert))
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
            },
            child: const Icon(Icons.comment_rounded),
          ),
        ),
        body: StreamBuilder(
          stream: Apis.firestore
              .collection(FireStoreConstant.collectionNameUsers)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              // if data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

              // if some or all data loaded
              case ConnectionState.active:
              case ConnectionState.done:
                // to map users
                final data = snapshot.data!.docs;
                _chatUserList =
                    data.map((e) => ChatUserModel.fromJson(e)).toList();
                if (_chatUserList.isNotEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: mq.width * .04, vertical: 4),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _isSearching
                        ? _searchList.length
                        : _chatUserList.length,
                    itemBuilder: (context, index) {
                      return ChatUserCard(
                        chatUserModel: _isSearching
                            ? _searchList[index]
                            : _chatUserList[index],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("No Users"),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
