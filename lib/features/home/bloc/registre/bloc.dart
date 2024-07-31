import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:insta_clone/features/home/repository/Registre_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/Registre_repo.dart';
import 'event.dart';
import 'state.dart';

class RegistreBloc extends Bloc<RegistreEvent, RegistreState> {
  final RegistreRepo registreRepo;

  RegistreBloc({required this.registreRepo}) : super(RegistreInitState()) {
    on<StartEvent>((event, emit) => emit(RegistreInitState()));

    on<Registrebuttonpressed>((event, emit) async {
      emit(RegistreLoadingState());
      try {
        var res = await registreRepo.registre(event.image, event.gender,event.website,event.fullName,event.bio,event.phoneNumber,event.categoryIds,event.email,event.password);
        print('eeeeeeeee');
print(res);
print(res.statusCode == 201);
        if (res.statusCode == 201) {
          emit(userRegistreSuccessState());
        } else {
          emit(userRegistreErrorState(message: 'verify email or password'));
        }
        print("token");
        var pref = await SharedPreferences.getInstance();

      } catch (error) {
        emit(userRegistreErrorState(message: "verifier vos champs"));
      }
    });

  }
}
