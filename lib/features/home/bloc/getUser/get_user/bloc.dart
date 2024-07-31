import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:insta_clone/features/home/repository/getUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../repository/Login_repo.dart';
import 'event.dart';
import 'state.dart';

class getUserBloc extends Bloc<getUserEvent, getUserState> {
  final getUserRepo getuserrepo;

  getUserBloc({required this.getuserrepo}) : super(getUserInitState()) {
    on<StartEvent>((event, emit) => emit(getUserInitState()));

    on<loginbuttonpressed>((event, emit) async {
      emit(getUserLoadingState());
      try {
        var res = await getuserrepo.getUserByToken();
        print('eeeeeeeee');
        var jsonResponse = jsonDecode(res.body);
        print(jsonResponse['accessToken']);

        if (res.statusCode == 200) {
          var pref = await SharedPreferences.getInstance();
          await pref.setString("token", jsonResponse['accessToken']);
          emit(getUserSuccessState());
        } else {
          emit(getUserErrorState(message: 'verify email or password'));
        }
        print("token");
        var pref = await SharedPreferences.getInstance();

        print(pref.getString('token'));
      } catch (error) {
        emit(getUserErrorState(message: error.toString()));
      }
    });

  }
}
