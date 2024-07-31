import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:insta_clone/features/home/repository/Story_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/Following_repo.dart';
import '../../repository/Following_repo.dart';
import 'event.dart';
import 'state.dart';

class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  final FollowingRepo followingRepo;

  FollowingBloc({required this.followingRepo}) : super(FollowingInitState()) {
    on<StartEvent>((event, emit) => emit(FollowingInitState()));

    on<addFollowingbuttonpressed>((event, emit) async {
      emit(FollowingLoadingState());
      try {
        var res = await followingRepo.AddFollowing(event.id);
        print('eeeeeeeee');
        print(res);
        print(res.statusCode == 200);
        if (res.statusCode == 200) {
          emit(AddFollowingSuccessState());
        } else {
          emit(AddFollowingErrorState(

              message: 'verify email or password'));
        }
        print("token");
        var pref = await SharedPreferences.getInstance();

      } catch (error) {
        emit(AddFollowingErrorState(message: "verifier vos champs"));
      }
    });

  }
}
