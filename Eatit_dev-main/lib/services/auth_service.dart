import 'package:eatit_dev/services/database_service.dart';
import 'package:eatit_dev/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//Sign in function
Future signInUserWithEmailandPassword(String email, String password) async{
  try{
    User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

    if(user!=null){
      return true;
    }
  }
  on FirebaseAuthException catch(e){
    return e.message;
  }
}

//Register User Function
Future signUpUserWithEmailandPassword(String userName, String email, String password) async{
  try{
    User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

    if(user!=null){
      //Call our database service to update the user data
      await DatabaseService(uid: user.uid).savingUserData(userName, email);
      return true;
    }
  }
  on FirebaseAuthException catch(e){
    return e.message;
  }
}


final googleSingIn = GoogleSignIn();

GoogleSignInAccount? _user;

GoogleSignInAccount get user => _user!;

Future googleSignin() async{
  final goolgeUser = await googleSingIn.signIn();
  if(goolgeUser == null) return;
  _user = goolgeUser;

  final googleAuth = await goolgeUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken:  googleAuth.idToken,
  );
  
  User user = (await firebaseAuth.signInWithCredential(credential)).user!;

  if(user!=null){
      final CollectionReference userCollection  = FirebaseFirestore.instance.collection("users");
      QuerySnapshot checkUserSnapshot = await userCollection.where("uid", isEqualTo: user.uid).get();
      if(checkUserSnapshot.docs.isEmpty){
        await DatabaseService(uid: user.uid).savingUserData(_user!.displayName!, _user!.email);
      }
      QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(_user!.email);
      await HelperFunctions.saveUserLoggedInStatus(true);
      await HelperFunctions.saveUserEmailSF(_user!.email);
      await HelperFunctions.saveUserNameSF(snapshot.docs[0]['userName']);
      return true;
    }

}


AccessToken? _accessToken;
Map<String, dynamic>? _userData;

Future facebookLogin() async {
    await FacebookAuth.instance.webAndDesktopInitialize(appId: '1272597870788187', cookie: true, xfbml: true, version: 'v20.0');
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      _accessToken = result.accessToken!;

      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;

      final credential = FacebookAuthProvider.credential(_accessToken.toString());
      User user = (await firebaseAuth.signInWithCredential(credential)).user!;

      if(user!=null){
      final CollectionReference userCollection  = FirebaseFirestore.instance.collection("users");
      QuerySnapshot checkUserSnapshot = await userCollection.where("uid", isEqualTo: user.uid).get();
      if(checkUserSnapshot.docs.isEmpty){
        await DatabaseService(uid: user.uid).savingUserData(_userData!['name'], _userData!['email']);
      }
      QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(_userData!['email']);
      await HelperFunctions.saveUserLoggedInStatus(true);
      await HelperFunctions.saveUserEmailSF(_userData!['email']);
      await HelperFunctions.saveUserNameSF(snapshot.docs[0]['userName']);
      return true;
    }

    }
    else {
      print(result.status);
      print(result.message);
      return false;
    }
  }

//Sign Out Function
Future signOut() async{
  try{
    await HelperFunctions.saveUserLoggedInStatus(false);
    await HelperFunctions.saveUserEmailSF("");
    await HelperFunctions.saveUserNameSF("");
    await firebaseAuth.signOut(); 
  }catch (e){
    return null;
  }
}
}
