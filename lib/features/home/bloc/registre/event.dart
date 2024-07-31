import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class RegistreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends RegistreEvent {}
class Registrebuttonpressed extends RegistreEvent{
  final Uint8List image;
  final String email;
  final String password;
  final String gender;
  final String website;
  final String fullName;
  final String bio;
  final String phoneNumber;
  final String categoryIds;
  Registrebuttonpressed({required this.image,required this.gender,required this.website,required this.fullName,required this.bio,required this.phoneNumber,required this.categoryIds, required this.email,required this.password});
}