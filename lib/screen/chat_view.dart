import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/models/chat_user_model.dart';
import 'package:whats_app/models/massage_model.dart';
import 'package:whats_app/widgets/custom_app_bar_chat_view.dart';
import 'package:whats_app/widgets/emoji_widget.dart';
import 'package:whats_app/widgets/massage_list_view.dart';

import '../main.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.user});
  final ChatUserModel user;

  @override
  State<ChatView> createState() => _ChatViewState();
}

bool emoji = false;
bool _isUploding = false;

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 234, 248, 255),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace:CustomAppBarChatView(chatUserModel: widget.user,),
        ),
        body: Column(
          children: [
            Expanded(
              child: MassageListView(
                chatUserModel: widget.user,
              ),
            ),
            if (_isUploding)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: CircularProgressIndicator()),
              ),
            _chatInput(),
            if (emoji)
              EmogiWidget(
                  textEditingController: _textEditingController,
                  scrollController: _scrollController),
          ],
        ),
      ),
    );
  }


  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.only(
          top: mq.height * .04,
          bottom: mq.height * .02,
          left: mq.width * .03,
          right: mq.width * .03),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        emoji = !emoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    scrollPadding: EdgeInsets.zero,
                    onTap: () {
                      if (emoji) setState(() => emoji = !emoji);
                    },
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
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      for (var i in images) {
                        log(i.path);
                        setState(() {
                          _isUploding = true;
                        });
                        await Apis.sendChatImage(widget.user, File(i.path));
                        setState(() {
                          _isUploding = false;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        log(image.path);
                        log(image.name);

                        await Apis.sendChatImage(widget.user, File(image.path));
                        setState(() {
                          _isUploding = false;
                        });
                      }
                    },
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

