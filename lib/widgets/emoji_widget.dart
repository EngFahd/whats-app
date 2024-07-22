
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:whats_app/main.dart';

class EmogiWidget extends StatelessWidget {
  const EmogiWidget({
    super.key,
    required TextEditingController textEditingController,
    required ScrollController scrollController,
  })  : _textEditingController = textEditingController,
        _scrollController = scrollController;

  final TextEditingController _textEditingController;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Offstage(
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
    );
  }
}
