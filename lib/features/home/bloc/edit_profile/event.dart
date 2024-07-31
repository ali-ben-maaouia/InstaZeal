import 'package:equatable/equatable.dart';

class EditProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends EditProfileEvent {}
class loginbuttonpressed extends EditProfileEvent{
  final String fullName;
  final String? phone;

  final String? bio;
  loginbuttonpressed({ required this.fullName, this.phone,this.bio});
}