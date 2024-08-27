// import "package:firebase_auth/firebase_auth.dart";
// import "package:flutter/material.dart";
// import "package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart";
// import 'package:harisfirebase/models/chat_user.dart';

// class CallScreen extends StatefulWidget {
//   final ChatUser chatUser; // The user to whom you're chatting

//   const CallScreen({super.key, required this.chatUser});

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   late final String currentUserId;
//   late final String currentUserName;

//   @override
//   void initState() {
//     super.initState();
//     // Getting the current user's ID and name
//     final user = FirebaseAuth.instance.currentUser!;
//     currentUserId = user.uid;
//     currentUserName = user.displayName ??
//         'Unknown'; // Replace 'Unknown' if displayName is null
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID:
//           256434165, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
//       appSign:
//           '2431039439c9503f49dade0528d2428debcfa4c506e83bbef675082e8b1eae76', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
//       userID: currentUserId, // Set the current user ID
//       userName: currentUserName, // Set the current user name
//       callID: 'call_demo_id_for_testing',
//       // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//     );
//   }
// }

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart";
import 'package:harisfirebase/models/chat_user.dart';
import 'package:harisfirebase/api/api.dart'; // Import API to use getConversationID

class CallScreen extends StatefulWidget {
  final ChatUser chatUser; // The user to whom you're chatting

  const CallScreen({super.key, required this.chatUser});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final String currentUserId;
  late final String currentUserName;
  late final String conversationID;

  @override
  void initState() {
    super.initState();
    // Getting the current user's ID and name
    final user = FirebaseAuth.instance.currentUser!;
    currentUserId = user.uid;
    currentUserName = user.displayName ?? 'Unknown';

    // Generate the conversationID based on the current user and chatUser
    conversationID = API.getConversationID(widget.chatUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID:
          256434165, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          '2431039439c9503f49dade0528d2428debcfa4c506e83bbef675082e8b1eae76', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: currentUserId, // Set the current user ID
      userName: currentUserName, // Set the current user name
      callID: conversationID, // Use the conversationID as the callID
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
