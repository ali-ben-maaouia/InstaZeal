import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:insta_clone/features/home/repository/Story_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event.dart';
import 'state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepo storyRepo;

  StoryBloc({required this.storyRepo}) : super(StoryInitState()) {
    on<StartEvent>((event, emit) => emit(StoryInitState()));

    on<addstorybuttonpressed>((event, emit) async {
      emit(StoryLoadingState());
      try {
        var res = await storyRepo.AddStory(event.description, event.storyImage);
        print('eeeeeeeee');
        print(res);
        print(res.statusCode == 201);
        if (res.statusCode == 201) {
          emit(AddStorySuccessState());
        } else {
          emit(AddStoryErrorState(

              message: 'verify email or password'));
        }
        print("token");
        var pref = await SharedPreferences.getInstance();

      } catch (error) {
        emit(AddStoryErrorState(message: "verifier vos champs"));
      }
    });

  }
}
