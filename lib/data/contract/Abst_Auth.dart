

// ignore_for_file: file_names

import 'package:rickmorty/domain/models/Person.dart';

abstract class AbstAuth {
  Future<Person> signIn({required String mail, required String password});
  
  Future<Person> signUp({required String mail, required String password});
  
  Future<bool> signOut();
}