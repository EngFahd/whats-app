// ignore: unused_import
import 'package:cached_network_image/cached_network_image.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/helper/my_date.dart';
import 'package:whats_app/main.dart';
import 'package:whats_app/models/chat_user_model.dart';
import 'package:whats_app/models/massage_model.dart';
import 'package:whats_app/screen/chat_view.dart';
import 'package:whats_app/widgets/profile_dialog.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.chatUserModel});
  final ChatUserModel chatUserModel;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

MessageModel? _messageModel;

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Apis.getLastMessage(widget.chatUserModel),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];
        if (list.isNotEmpty) {
          _messageModel = list[0];
        }
        return Card(
          margin: EdgeInsets.symmetric(horizontal: mq.width * .01, vertical: 4),
          elevation: 0.5,
          // color: Colors.blue.shade100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatView(
                    user: widget.chatUserModel,
                  ),
                ),
              );
            },
            child: ListTile(
              title: Text(
                widget.chatUserModel.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _messageModel != null
                    ? _messageModel!.type == Type.image
                        ? 'Your resived an image 📩'
                        : _messageModel!.msg
                    : widget.chatUserModel.about,
                maxLines: 1,
              ),
              trailing: _messageModel == null
                  ? null
                  : _messageModel!.read.isEmpty &&
                          _messageModel!.fromId != Apis.user.uid
                      ? Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: widget.chatUserModel.isOnline
                                ? Colors.green
                                : Colors.grey,
                          ),
                        )
                      : Text(
                          MyDate.getLastMessageTime(
                              context: context, time: _messageModel!.sent),
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
              leading: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return ProfileDialog(user: widget.chatUserModel);
                      });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    height: mq.height * 0.055,
                    width: mq.height * 0.055,
                    imageUrl: widget.chatUserModel.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),

                    // ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
