import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
List<ChatUserModel> chatUserList = [];
bool _isSearching = false;

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const Icon(CupertinoIcons.home),
          title: _isSearching
              ? const TextField(
                  decoration: InputDecoration(border: InputBorder.none),
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
        body: const Chat());
  }
}
