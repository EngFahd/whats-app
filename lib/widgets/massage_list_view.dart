import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/main.dart';
import 'package:whats_app/models/chat_user_model.dart';
import 'package:whats_app/models/massage_model.dart';
import 'package:whats_app/widgets/massage_card.dart';

class MassageListView extends StatefulWidget {
  const MassageListView({super.key, required this.chatUserModel});
  final ChatUserModel chatUserModel;
  @override
  State<MassageListView> createState() => _MassageCardState();
}

List<MessageModel> list = [];

final TextEditingController _textEditingController = TextEditingController();

class _MassageCardState extends State<MassageListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Apis.getAllMessages(widget.chatUserModel),
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
            final data = snapshot.data?.docs;
            list = data?.map((e) => MessageModel.fromJson(e.data())).toList() ??
                [];
            // list.add(MassageModel(
            //     told: "xyz",
            //     type: Type.text,
            //     msg: "hi",
            //     read: " ",
            //     fromId: Apis.user.uid,
            //     sent: "12:00"));
            // list.add(MassageModel(
            //     told: Apis.user.uid,
            //     type: Type.text,
            //     msg: "hello",
            //     read: " ",
            //     fromId: "xyz",
            //     sent: "12:05"));
            if (list.isNotEmpty) {
              return ListView.builder(
                reverse: true,
                padding: EdgeInsets.symmetric(
                    horizontal: mq.width * .04, vertical: 4),
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return MassageCard(
                    massageModel: list[index],
                  );
                },
              );
            } else {
              return const Center(
                child: Text("Say hi"),
              );
            }
        }
      },
    );
  }
}
