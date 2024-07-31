 import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends LoginEvent {}
class loginbuttonpressed extends LoginEvent{
  final String email;
  final String password;
  loginbuttonpressed({required this.email,required this.password});
}