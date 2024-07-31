import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:insta_clone/features/home/repository/EditProfile_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event.dart';
import 'state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileRepo editProfileRepo;

  EditProfileBloc({required this.editProfileRepo}) : super(EditProfileInitState()) {
    on<StartEvent>((event, emit) => emit(EditProfileInitState()));

    on<loginbuttonpressed>((event, emit) async {
      emit(EditProfileLoadingState());
      try {
        var res = await editProfileRepo.EditProfile(event.fullName, event.phone,event.bio);
        print('eeeeeeeee');
        var jsonResponse = jsonDecode(res.body);
        print(res.statusCode == 200);

        if (res.statusCode == 200) {

          emit(EditProfileSuccessState());
        } else {
          emit(EditProfileErrorState(message: 'verify email or password'));
        }
        print("token");
        var pref = await SharedPreferences.getInstance();

        print(pref.getString('token'));
      } catch (error) {
        emit(EditProfileErrorState(message:  error.toString()));
      }
    });

  }
}
