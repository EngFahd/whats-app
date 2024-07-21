import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whats_app/core/helper/apis.dart';
import 'package:whats_app/core/helper/my_date.dart';
import 'package:whats_app/main.dart';
import 'package:whats_app/models/chat_user_model.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({
    super.key,
    this.user,
  });
  final ChatUserModel? user;
  @override
  State<ViewProfileScreen> createState() => _ProfilState();
}

class _ProfilState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      // onTap: () => Focus.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.user!.name),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Joined On : ",
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            Text(
              MyDate.getLastMessageTime(
                time: widget.user!.createdAt,
                context: context,
              ),
              style: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: mq.width,
                  height: mq.height * .03,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .5),
                  child: Image.network(
                    height: mq.height * .2,
                    width: mq.height * .2,
                    fit: BoxFit.cover,
                    Apis.user.photoURL.toString(),
                    // scale: .5,
                  ),
                ),

                // adding spase

                SizedBox(height: mq.height * .03),

                Text(widget.user!.name),

                // adding spase
                SizedBox(height: mq.height * .02),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("About : ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16)),
                    Text(
                      widget.user!.about,
                      style: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
