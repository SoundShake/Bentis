import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/%20services/database.dart';
import 'package:untitled/models/user.dart';

class AuthService
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

// create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User user)
  {
    return user != null ? MyUser(uid: user.uid) : null;
  }
// auth change user stream
  Stream<MyUser?> get user{
    return _auth.authStateChanges().map((User? user)=>_userFromFirebaseUser(user!));
  }

  // sign in anon
  Future signInAnon() async {
    try{
        UserCredential result = await _auth.signInAnonymously();
        User? user = result.user;
        return _userFromFirebaseUser(user!);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async
  {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async
  {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      //create a new document for user with the uid

      await DatabaseService(uid: user!.uid).updateUserData('name', 'surname', 'phoneNumber','imageUrl');
      return _userFromFirebaseUser(user!);

    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async
  {
    try{
      return await _auth.signOut();
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
}