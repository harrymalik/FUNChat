import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harisfirebase/api/api.dart';
import 'package:harisfirebase/helper/dialogs.dart';
import 'package:harisfirebase/models/chat_user.dart';
import 'package:harisfirebase/widgets/chat_user_cart.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;

  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final exists = await API.userExists();
    if (!exists) {
      await API.createUser();
    } else {
      final userDoc =
          await API.firestore.collection('users').doc(API.user.uid).get();
      API.me = ChatUser.fromJson(userDoc.data()!);
    }

    await _updateFirebaseMessagingToken();
  }

  Future<void> _updateFirebaseMessagingToken() async {
    final token = await API.getFirebaseMessagingToken();
    if (token != null && token.isNotEmpty) {
      await API.firestore
          .collection('users')
          .doc(API.user.uid)
          .update({'push_token': token});
    }
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        centerTitle: true,
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name, Email, ...'),
                autofocus: true,
                style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                onChanged: (val) {
                  _searchList.clear();
                  val = val.toLowerCase();

                  for (var i in list) {
                    if (i.name.toLowerCase().contains(val) ||
                        i.email.toLowerCase().contains(val)) {
                      _searchList.add(i);
                    }
                  }
                  setState(() => _searchList);
                })
            : const Text("Funny Chat"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(_isSearching
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search)),
        ],
      ),
      body: StreamBuilder(
        stream: API.getMyUsersId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData &&
              snapshot.data?.docs.isNotEmpty == true) {
            return StreamBuilder(
              stream: API.getAllUsers(
                  snapshot.data?.docs.map((e) => e.id).toList() ?? []),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData &&
                    snapshot.data?.docs.isNotEmpty == true) {
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (list.isNotEmpty) {
                    return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : list.length,
                        padding: const EdgeInsets.only(top: 0.1),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatUserCart(
                              user: _isSearching
                                  ? _searchList[index]
                                  : list[index]);
                        });
                  }
                }
                return const Center(
                  child: Text('No connections found',
                      style: TextStyle(fontSize: 20)),
                );
              },
            );
          } else {
            return const Center(
              child:
                  Text('No connections found', style: TextStyle(fontSize: 20)),
            );
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () => _addChatUserDialog(),
                child: const Icon(Icons.add_comment_rounded),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => signout(),
                child: const Icon(Icons.logout_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: const InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),
                MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await API.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(context, 'User not found');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
