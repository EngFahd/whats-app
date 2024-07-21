import 'dart:developer';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/helper/my_date.dart';
import 'package:whats_app/core/utils/routes.dart';
import 'package:whats_app/models/chat_user_model.dart';
import 'package:whats_app/models/massage_model.dart';
import 'package:whats_app/screen/view_profile_screen.dart';
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
          flexibleSpace: _appBar(context),
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
              Offstage(
                offstage: false,
                child: SizedBox(
                  height: mq.height * 0.35,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {},
                    textEditingController: _textEditingController,
                    scrollController: _scrollController,
                    config: Config(
                      swapCategoryAndBottomBar: false,
                      skinToneConfig: const SkinToneConfig(),
                      categoryViewConfig: const CategoryViewConfig(),
                      bottomActionBarConfig: const BottomActionBarConfig(),
                      searchViewConfig: const SearchViewConfig(),
                      checkPlatformCompatibility: true,
                      height: 256,
                      emojiViewConfig: EmojiViewConfig(
                        columns: 7,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        // backgroundColor: const Color(0xFFF2F2F2),
                        emojiSizeMax: (Platform.isIOS ? 1.20 : 1.0),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ViewProfileScreen(
              user: widget.user,
            );
          },
        ));
      },
      child: StreamBuilder(
          stream: Apis.getUserInfo(widget.user),
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
                        list.isNotEmpty ? list[0].image : widget.user.image,
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
                          list.isNotEmpty ? list[0].name : widget.user.name,
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
                                  lastActive: widget.user.lastActive),
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
