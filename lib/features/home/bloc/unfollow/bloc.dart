import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:insta_clone/features/home/repository/Story_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/Following_repo.dart';
import '../../repository/Following_repo.dart';
import '../../repository/UnFollowin_repo.dart';
import 'event.dart';
import 'state.dart';

class UnFollowingBloc extends Bloc<UnFollowingEvent, UnFollowingState> {
  final UnFollowingRepo unFollowingRepo;

  UnFollowingBloc({required this.unFollowingRepo}) : super(UnFollowingInitState()) {
    on<StartEvent>((event, emit) => emit(UnFollowingInitState()));

    on<addUnFollowingbuttonpressed>((event, emit) async {
      emit(UnFollowingLoadingState());
      try {
        var res = await unFollowingRepo.AddUnFollowing(event.id);
        print('eeeeeeeee');
        print(res);
        print(res.statusCode == 200);
        if (res.statusCode == 200) {
          emit(UnAddFollowingSuccessState());
        } else {
          emit(UnAddFollowingErrorState(

              message: 'verify email or password'));
        }
        print("token");
        var pref = await SharedPreferences.getInstance();

      } catch (error) {
        emit(UnAddFollowingErrorState(message: "verifier vos champs"));
      }
    });

  }
}
