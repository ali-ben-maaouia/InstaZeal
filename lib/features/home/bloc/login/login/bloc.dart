import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repository/Login_repo.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo loginRepo;

  LoginBloc({required this.loginRepo}) : super(LoginInitState()) {
    on<StartEvent>((event, emit) => emit(LoginInitState()));

    on<loginbuttonpressed>((event, emit) async {
      emit(LoginLoadingState());
      try {
        var res = await loginRepo.login(event.email, event.password);
        print('eeeeeeeee');
        var jsonResponse = jsonDecode(res.body);
        print(jsonResponse['accessToken']);

        if (res.statusCode == 200) {
          var pref = await SharedPreferences.getInstance();
    await pref.setString("token", jsonResponse['accessToken']);
          emit(userLoginSuccessState());
        } else {
          emit(userLoginErrorState(message: 'verify email or password'));
        }
        print("token");
        var pref = await SharedPreferences.getInstance();

        print(pref.getString('token'));
      } catch (error) {
        emit(userLoginErrorState(message: error.toString()));
      }
    });

  }
}
