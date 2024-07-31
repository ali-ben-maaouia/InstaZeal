import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:insta_clone/features/home/repository/AddPost.dart';
import 'package:insta_clone/features/home/repository/Story_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event.dart';
import 'state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final AddPostRepo addPostRepo;

  AddPostBloc({required this.addPostRepo}) : super(AddPostInitState()) {
    on<StartEvent>((event, emit) => emit(AddPostInitState()));

    on<AddPostbuttonpressed>((event, emit) async {
      emit(AddPostLoadingState());
      try {
        print("adddd");
        var res = await addPostRepo.AddPost(event.description,event.categoryId, event.PostImage);
        print('eeeeeeeee');
        print(res);
        print(res.statusCode == 200);
        if (res.statusCode == 200) {
          emit(AddPostSuccessState());
        } else {
          emit(AddPostErrorState(

              message: 'verify email or password'));
        }
        print("token");
        var pref = await SharedPreferences.getInstance();

      } catch (error) {
        emit(AddPostErrorState(message: "verifier vos champs"));
      }
    });

  }
}
