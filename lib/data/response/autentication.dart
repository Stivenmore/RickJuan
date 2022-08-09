import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rickmorty/data/contract/Abst_Auth.dart';
import 'package:rickmorty/domain/models/Person.dart';

class Autentication implements AbstAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  late Person person;

  @override
  Future<Person> signIn(
      {required String mail, required String password}) async {
    try {
      final resp = await _auth.signInWithEmailAndPassword(
          email: mail, password: password);
      if (resp.user != null) {
        user = resp.user;
        final resp2 =
            await _firestore.collection("Users").doc(resp.user!.uid).get();
        person = Person.fromJson(resp2.data());
        return person;
      } else {
        return person;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Person> signUp(
      {required String mail, required String password}) async {
    try {
      final resp = await _auth.createUserWithEmailAndPassword(
          email: mail, password: password);
      if (resp.user != null) {
        user = resp.user;
        await _firestore.collection("Users").doc(resp.user!.uid).set({
          "Name": resp.user!.displayName?? mail.split('@')[0].replaceAll('.', ' '),
          "Email": resp.user!.email,
          "UID": resp.user!.uid
        });
        return Person(
            name: resp.user!.displayName?? mail.split('@')[0].replaceAll('.', ' '),
            email: resp.user!.email,
            uid: resp.user!.uid);
      } else {
        return Person(name: '', email: '', uid: '');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      person = Person(name: '', email: '', uid: '');
      return true;
    } catch (e) {
      return false;
    }
  }
}
