// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeDemo extends StatefulWidget {
  GoogleSignInAccount user;
  Function sinout;
  HomeDemo(this.user, this.sinout, {Key? key}) : super(key: key);

  @override
  State<HomeDemo> createState() => _HomeDemoState();
}

class _HomeDemoState extends State<HomeDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
              onPressed: () {
                widget.sinout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: widget.user,
            ),
            title: Text(widget.user.displayName ?? ''),
            subtitle: Text(widget.user.email),
          ),
          const Text("Signed in successfully."),
          ElevatedButton(
            child: const Text('SIGN OUT'),
            onPressed: () {
              widget.sinout();
            },
          ),
        ],
      ),
    );
  }
}
