import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  bool hide = true;
  void togglePasswordVisibility() {
    hide = !hide;
    emit(PasswordVisibility(hide));
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginInitial());
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errorMessage: 'user-not-found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errorMessage: 'wrong-password'));
      } else if (e.code == 'invalid-email') {
        emit(LoginFailure(errorMessage: 'invalid-email'));
      } else {
        emit(LoginFailure(errorMessage: 'An error occurred while logging in.'));
      }
    }
  }
}
