
import 'package:flutter/material.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/utils/constant.dart';
import 'package:whats_app/main.dart';
import 'package:whats_app/widgets/chat_user_card.dart';
import 'package:whats_app/models/chat_user_model.dart';

class Chat extends StatelessWidget {
   Chat({super.key, this.chatUserModelList});
 late List<ChatUserModel>? chatUserModelList;
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
            chatUserModelList = data.map((e) => ChatUserModel.fromJson(e)).toList();
            if (chatUserModelList!.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: mq.width * .04, vertical: 4),
                physics: const BouncingScrollPhysics(),
                itemCount: chatUserModelList!.length,
                itemBuilder: (context, index) {
                  return ChatUserCard(
                    chatUserModel: chatUserModelList![index],
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

// to collect users from database
