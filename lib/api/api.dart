import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:harisfirebase/api/access_firebase_token.dart';
import 'package:harisfirebase/models/chat_user.dart';
import 'package:harisfirebase/models/message.dart';
import 'package:http/http.dart' as http;

class API {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;
  static late ChatUser me;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    print('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      print('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  static Future<ChatUser> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      about: "Hey! I'm using Chat Haris",
      createdAt: time,
      email: user.email.toString(),
      id: user.uid,
      image: user.photoURL.toString(),
      isOnline: false,
      lastActive: time,
      name: user.displayName.toString(),
      pushToken: '',
    );

    await firestore.collection('users').doc(user.uid).set(chatUser.toJson());

    // Initialize `me` with the created user
    me = chatUser;

    // Return the created user
    return me;
  }

  static Future<void> initializeMe() async {
    if (await userExists()) {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await firestore.collection('users').doc(user.uid).get();
      me = ChatUser.fromJson(doc.data()!);
    } else {
      await createUser();
    }
  }

  // for getting firebase messaging token
  static Future<String?> getFirebaseMessagingToken() async {
    // Retrieve the Firebase Messaging token
    return await FirebaseMessaging.instance.getToken();
  }

  static Future<void> updatePushToken(String token) async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'push_token': token});
  }

  static Future<void> deleteConversation(ChatUser chatUser) async {
    // Get the conversation ID based on the two user IDs
    String conversationID = getConversationID(chatUser.id);

    // Reference to the chat messages in Firestore
    CollectionReference messagesRef =
        firestore.collection('chats/$conversationID/messages/');

    // Delete all messages in the conversation
    QuerySnapshot messagesSnapshot = await messagesRef.get();
    for (DocumentSnapshot doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Optionally, remove the conversation reference in both users' 'my_users' collections
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .doc(chatUser.id)
        .delete();
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .delete();
  }

  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.told)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.message).delete();
    }
  }

  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    AccessFirebaseToken accessToken = AccessFirebaseToken();
    String bearerToken = await accessToken.getAccessToken();
    final body = {
      "message": {
        "token": chatUser.pushToken,
        "notification": {"title": me.email, "body": msg},
      }
    };
    try {
      var res = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/harisfirebase-bbce4/messages:send'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $bearerToken'
        },
        body: jsonEncode(body),
      );
      print("Response statusCode: ${res.statusCode}");
      print("Response body: ${res.body}");
    } catch (e) {
      print("\nsendPushNotification: $e");
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> usersIDs) {
    print('userids , $usersIDs');
    return firestore
        .collection('users')
        .where('id', whereIn: usersIDs)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessages(chatUser, msg, type));
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        // .orderBy('send', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatID(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/')
        // .orderBy('send', descending: true)
        .snapshots();
  }

  static Future<void> sendMessages(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // Message to send
    final Message message = Message(
      formid: user.uid,
      message: msg,
      read: '',
      sent: time,
      told: chatUser.id,
      type: type,
    );
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref
        .doc(time)
        .set(message.toJson())
        .then((Value) => sendPushNotification(chatUser, msg));
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessages(chatUser, imageUrl, Type.image);
  }
}
