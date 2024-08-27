import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harisfirebase/api/api.dart';
import 'package:harisfirebase/screens/call_screen.dart';
import 'package:harisfirebase/models/chat_user.dart';
import 'package:harisfirebase/models/message.dart';
import 'package:harisfirebase/widgets/message_card.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: API.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();

                    //if some or all data is loaded then show it
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      ////log('messages: ${jsonEncode(data![0].data())}');
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                            reverse: false,
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: 0.1),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(message: _list[index]);
                            });
                      } else {
                        return const Center(
                          child:
                              Text('Say Hii', style: TextStyle(fontSize: 20)),
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput()
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 234, 248, 255),
      ),
    );
  }

  Widget _appBar() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                // Add navigation functionality
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black45,
              ),
            ),
            CircleAvatar(
              child: Icon(CupertinoIcons.person),
            ),
            SizedBox(width: 8), // Add some spacing between avatar and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.email,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'last seen at 10:00 PM',
                  maxLines: 1,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
            Spacer(), // Add a spacer to push the status indicator to the end
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallScreen(chatUser: widget.user),
                ),
              );
            },
            icon: const Icon(
              Icons.video_camera_back,
              color: Colors.blueAccent,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Type Something...',
                hintStyle: TextStyle(color: Colors.blueAccent),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
// Pick an image.
              final List<XFile> images =
                  await picker.pickMultiImage(imageQuality: 80);
              for (var i in images) {
                print('images path: ${i.path}');
                await API.sendChatImage(widget.user, File(i.path));
              }
            },
            icon: const Icon(
              Icons.image,
              color: Colors.blueAccent,
            ),
          ),
          IconButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
// Pick an image.
              final XFile? image = await picker.pickImage(
                  source: ImageSource.camera, imageQuality: 80);
              if (image != null) {
                print('image path: ${image.path} ');
                API.sendChatImage(widget.user, File(image.path));
              }
            },
            icon: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.blueAccent,
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  API.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  API.sendMessages(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.all(10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }
}
