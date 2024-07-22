import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/helper/my_date.dart';
import 'package:whats_app/main.dart';
import 'package:whats_app/models/chat_user_model.dart';
import 'package:whats_app/screen/view_profile_screen.dart';

class CustomAppBarChatView extends StatelessWidget {
  const CustomAppBarChatView({
    super.key, required this.chatUserModel,
  });

  final ChatUserModel chatUserModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ViewProfileScreen(
                user: chatUserModel,
              );
            },
          ),
        );
      },
      child: StreamBuilder(
          stream: Apis.getUserInfo(chatUserModel),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ??
                    [];

            return Container(
              margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: InkWell(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: Image.network(
                        list.isNotEmpty ? list[0].image : chatUserModel.image,
                        height: mq.height * 0.055,
                        width: mq.height * 0.055,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list.isNotEmpty ? list[0].name : chatUserModel.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                                  ? "isOnline"
                                  : MyDate.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive)
                              : MyDate.getLastActiveTime(
                                  context: context,
                                  lastActive: chatUserModel.lastActive),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
