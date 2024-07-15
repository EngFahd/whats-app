import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/models/chat_user_model.dart';

class ChatUserCard extends StatelessWidget {
  const ChatUserCard({super.key, required this.chatUserModel});
  final ChatUserModel chatUserModel;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .01, vertical: 4),
      elevation: 0.5,
      // color: Colors.blue.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        child: ListTile(
          title: Text(
            chatUserModel.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            chatUserModel.about,
            maxLines: 1,
          ),
          trailing: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: chatUserModel.isOnline ? Colors.green : Colors.grey,
            ),
          ),
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: Image.network(chatUserModel.image)
              //  CachedNetworkImage(
              //   height: mq.height * 0.055,
              //   width: mq.height * 0.055,
              //   imageUrl: chatUserModel.image,
              //   placeholder: (context, url) => const CircularProgressIndicator(),
              //   errorWidget: (context, url, error) => const CircleAvatar(
              //     child: Icon(CupertinoIcons.person),
              //   ),
           
              // ),
              ),
        ),
      ),
    );
  }
}
