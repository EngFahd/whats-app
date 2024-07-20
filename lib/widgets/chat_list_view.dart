import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/utils/constant.dart';
import 'package:whats_app/main.dart';
import 'package:whats_app/widgets/chat_user_card.dart';
import 'package:whats_app/models/chat_user_model.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

// to collect users from database
List<ChatUserModel> chatUserList = [];

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
     mq = MediaQuery.of(context).size;
    return StreamBuilder(
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
            chatUserList = data.map((e) => ChatUserModel.fromJson(e)).toList();
            if (chatUserList.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: mq.width * .04, vertical: 4),
                physics: const BouncingScrollPhysics(),
                itemCount: chatUserList.length,
                itemBuilder: (context, index) {
                  return ChatUserCard(
                    chatUserModel: chatUserList[index],
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
    );
  }
}
