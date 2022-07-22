import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'authForm.dart';

// ignore: must_be_immutable
class AuthScreen extends StatefulWidget {
  GoogleSignInAccount? user;
  Function signOutFromGoogle;
  // ignore: use_key_in_widget_constructors
  AuthScreen(
    this.user,
    this.signOutFromGoogle,
  );
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _submitAuthForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
      } else {}
    } on PlatformException catch (err) {
      var message = "An error occured please check your credentails";

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // ignore: avoid_print
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthForm(
        submitFn: _submitAuthForm,
        isLoading: _isLoading,
        user: widget.user,
        signOutFromGoogle: widget.signOutFromGoogle);
  }
}
