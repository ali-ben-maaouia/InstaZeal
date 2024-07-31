import 'package:equatable/equatable.dart';

class LoginState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class LoginInitState extends LoginState{}

class LoginLoadingState extends LoginState{}

class userLoginSuccessState extends LoginState{}

class userLoginErrorState extends LoginState{
  final String message;
  userLoginErrorState( {required this.message});
}
