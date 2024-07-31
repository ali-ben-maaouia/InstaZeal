import 'package:equatable/equatable.dart';

class RegistreState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class RegistreInitState extends RegistreState{}

class RegistreLoadingState extends RegistreState{}

class userRegistreSuccessState extends RegistreState{}

class userRegistreErrorState extends RegistreState{
  final String message;
  userRegistreErrorState( {required this.message});
}
