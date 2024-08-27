import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harisfirebase/api/api.dart';
import 'package:harisfirebase/screens/chat_screen.dart';
import 'package:harisfirebase/models/chat_user.dart';

class ChatUserCart extends StatefulWidget {
  final ChatUser user;
  const ChatUserCart({super.key, required this.user});

  @override
  State<ChatUserCart> createState() => _ChatUserCartState();
}

class _ChatUserCartState extends State<ChatUserCart> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        // onLongPress: () {
        //   API.deleteConversation(widget.user);
        // },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(user: widget.user),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent.shade100,
            radius: 25,
            child: Icon(CupertinoIcons.person, color: Colors.white, size: 30),
          ),
          title: Text(
            widget.user.email,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              API.deleteConversation(widget.user);
              // Handle delete functionality here
            },
          ),
        ),
      ),
    );
  }
}
