import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatefulWidget {
  final snap;
  const ChatCard({super.key, required this.snap});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    bool isUser = widget.snap['uid'] == FirebaseAuth.instance.currentUser!.uid;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profilePic']),
              radius: 18,
            ),
          SizedBox(width: isUser ? 8 : 16),
          Container(
            decoration: BoxDecoration(
              color: isUser ? Colors.grey[300] : Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.snap['text'],
                        style: TextStyle(color: isUser ? Colors.black : Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          if (isUser)
            SizedBox(width: 8),
          if (isUser)
            CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['profilePic']),
              radius: 18,
            ),
        ],
      ),
    );
  }
}
