import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/helper/my_date.dart';
import 'package:whats_app/main.dart';
import 'package:whats_app/models/massage_model.dart';

class MassageCard extends StatelessWidget {
  const MassageCard({super.key, required this.massageModel});
  final MessageModel massageModel;
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == massageModel.fromId
        ? GreenMassages(
            massageModel: massageModel,
          )
        : BlueMassage(
            massageModel: massageModel,
          );
  }
}

class GreenMassages extends StatelessWidget {
  const GreenMassages({super.key, required this.massageModel});
  final MessageModel massageModel;
  @override
  Widget build(BuildContext context) {
    if (massageModel.msg.isEmpty) {
      Apis.updateMessageReadStatus(massageModel);
      log("message updated");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(massageModel.msg == Type.image
                ? mq.height * .005
                : mq.height * .025),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  221,
                  245,
                  255,
                ),
                border: Border.all(
                  color: Colors.lightBlue,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: massageModel.type == Type.text
                ? Text(
                    massageModel.msg,
                    style: const TextStyle(fontSize: 15),
                  )
                : CachedNetworkImage(
                    imageUrl: massageModel.msg,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: mq.width * .04,
          ),
          child: Text(
            MyDate.getFormattedTime(
                dateTime: massageModel.sent, context: context),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        )
      ],
    );
  }
}

class BlueMassage extends StatelessWidget {
  const BlueMassage({super.key, required this.massageModel});
  final MessageModel massageModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            const Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              MyDate.getFormattedTime(
                  dateTime: massageModel.sent, context: context),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(massageModel.msg == Type.image
                ? mq.height * .005
                : mq.height * .025),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  218,
                  255,
                  176,
                ),
                border: Border.all(
                  color: Colors.lightBlue,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: massageModel.type == Type.text
                ? Text(
                    massageModel.msg,
                    style: const TextStyle(fontSize: 15),
                  )
                : CachedNetworkImage(
                    imageUrl: massageModel.msg,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
