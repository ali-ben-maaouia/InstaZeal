import 'package:equatable/equatable.dart';

class getUserState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class getUserInitState extends getUserState{}

class getUserLoadingState extends getUserState{}

class getUserSuccessState extends getUserState{}

class getUserErrorState extends getUserState{
  final String message;
  getUserErrorState( {required this.message});
}
