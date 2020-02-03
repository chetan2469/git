import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final cFireBaseAuth = FirebaseAuth.instance;

final cGoogleSignIn = GoogleSignIn();


const cAnimationDuration = 700;

const cLognScreenRouteName = 'LoginScreen';
class Constants{
  static bool mode;
  static int fontSize;
}