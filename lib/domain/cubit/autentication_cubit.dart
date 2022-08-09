import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/data/response/autentication.dart';
import 'package:rickmorty/domain/models/Person.dart';

part 'autentication_state.dart';

class AutenticationCubit extends Cubit<AutenticationState> {
  final Autentication _autentication;
  AutenticationCubit({required Autentication autentication})
      : _autentication = autentication,
        super(AutenticationInitial());

  User? get user => _autentication.user;
  late Person person;

  Future signIn({required String mail, required String password}) async {
    try {
      emit(AutenticationLoading());
      person = await _autentication.signIn(mail: mail, password: password);
      if (person.uid != null) {
        emit(AutenticationLoaded());
      } else {
        emit(AutenticationError());
      }
    } catch (e) {
      emit(AutenticationError());
    }
  }

  Future signUp({required String mail, required String password}) async {
    try {
      emit(AutenticationLoading());
      person = await _autentication.signUp(mail: mail, password: password);
      if (person.uid != null) {
        emit(AutenticationLoaded());
      } else {
        emit(AutenticationError());
      }
    } catch (e) {
      emit(AutenticationError());
    }
  }

  Future signOut() async {
    try {
      emit(AutenticationLoading());
      bool value = await _autentication.signOut();
      if (value) {
        emit(AutenticationLoaded());
      } else {
        emit(AutenticationError());
      }
    } catch (e) {
      emit(AutenticationError());
    }
  }

  void initialState(){
    emit(AutenticationInitial());
  }
}
