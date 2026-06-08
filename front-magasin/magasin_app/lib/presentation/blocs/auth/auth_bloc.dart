import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import '../../../../data/services/api_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {

    on<LoginEvent>((event, emit) async {

      emit(AuthLoading());

      try {
        final response =
            await ApiService.login(event.email, event.password);

        if (response['token'] != null) {

          // Sauvegarder token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response['token']);

          emit(AuthSuccess(response['token']));
        } else {
          emit(AuthFailure(response['message'] ?? 'Erreur login'));
        }

      } catch (e) {
        emit(AuthFailure("Erreur serveur"));
      }
    });
  }
}