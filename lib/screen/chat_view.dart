import 'package:flutter/material.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/models/chat_user_model.dart';
import 'package:whats_app/models/massage_model.dart';
import 'package:whats_app/widgets/massage_list_view.dart';

import '../main.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.user});
  final ChatUserModel user;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 248, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: MassageListView(
              chatUserModel: widget.user,
            ),
          ),
          _chatInput(),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
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
                widget.user.image,
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
                  widget.user.name,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Last sean 20:11",
                  style: TextStyle(
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
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .04, horizontal: mq.width * .03),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    controller: _textEditingController,
                    onSubmitted: (value) {},
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Type some thing...",
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                    ),
                  ),
                  SizedBox(width: mq.width * .03)
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textEditingController.text.isNotEmpty) {
                Apis.sendMessage(
                    widget.user, _textEditingController.text, Type.text);
                    _textEditingController.clear();
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.blue,
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
