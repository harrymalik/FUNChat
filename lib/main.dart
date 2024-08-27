// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:harisfirebase/api/api.dart';
// import 'package:harisfirebase/widgets/chat_user_cart.dart';
import 'package:harisfirebase/wrapper.dart';
import 'package:get/get.dart';
// import 'models/chat_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp? firebaseApp;
  try {
    firebaseApp = await Firebase.initializeApp();

    await API.initializeMe();

    // Now it's safe to call getFirebaseMessagingToken
    await API.getFirebaseMessagingToken();
  } catch (e) {
    // Handle initialization error
    print('Failed to initialize Firebase: $e');
  }
  runApp(MyApp(firebaseApp: firebaseApp));
}

class MyApp extends StatelessWidget {
  final FirebaseApp? firebaseApp;

  const MyApp({super.key, required this.firebaseApp});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: firebaseApp == null ? const ErrorScreen() : const wrapper(),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('Failed to initialize Firebase'),
      ),
    );
  }
}

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   final user = FirebaseAuth.instance.currentUser;

//   List<ChatUser> list = [];
//   final List<ChatUser> _searchList = [];
//   bool _isSearching = false;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the user and get the FCM token
//     _initializeUser();
//   }

//   Future<void> _initializeUser() async {
//     // Check if the user already exists in Firestore
//     final exists = await API.userExists();
//     if (!exists) {
//       // Create a new user if it doesn't exist
//       await API.createUser();
//     } else {
//       // Load the existing user data from Firestore
//       final userDoc =
//           await API.firestore.collection('users').doc(API.user.uid).get();
//       API.me = ChatUser.fromJson(userDoc.data()!);
//     }

//     // Get the FCM token
//     await API.getFirebaseMessagingToken();
//   }

//   signout() async {
//     await FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const Icon(CupertinoIcons.home),
//         centerTitle: true,
//         title: _isSearching
//             ? TextField(
//                 decoration: const InputDecoration(
//                     border: InputBorder.none, hintText: 'Name, Email, ...'),
//                 autofocus: true,
//                 style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
//                 onChanged: (val) {
//                   // Search logic
//                   _searchList.clear();

//                   val = val.toLowerCase();

//                   for (var i in list) {
//                     if (i.name.toLowerCase().contains(val) ||
//                         i.email.toLowerCase().contains(val)) {
//                       _searchList.add(i);
//                     }
//                   }
//                   setState(() => _searchList);
//                 })
//             : Text("Funny Chat"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   _isSearching = !_isSearching;
//                 });
//               },
//               icon: Icon(_isSearching
//                   ? CupertinoIcons.clear_circled_solid
//                   : Icons.search)),
//         ],
//       ),
//       body: StreamBuilder(
//         stream: API.getAllUsers(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//             case ConnectionState.none:
//               return const Center(child: CircularProgressIndicator());

//             // If some or all data is loaded then show it
//             case ConnectionState.active:
//             case ConnectionState.done:
//               final data = snapshot.data?.docs;
//               list =
//                   data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

//               if (list.isNotEmpty) {
//                 return ListView.builder(
//                     itemCount: _isSearching ? _searchList.length : list.length,
//                     padding: EdgeInsets.only(top: 0.1),
//                     physics: BouncingScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return ChatUserCart(
//                           user:
//                               _isSearching ? _searchList[index] : list[index]);
//                       // Return Text('Name: ${list[index]}');
//                     });
//               } else {
//                 return const Center(
//                   child: Text('connection not found',
//                       style: TextStyle(fontSize: 20)),
//                 );
//               }
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => signout(),
//         child: Icon(Icons.login_rounded),
//       ),
//     );
//   }
// }
