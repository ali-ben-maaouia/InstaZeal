import 'package:equatable/equatable.dart';

class UnFollowingState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class UnFollowingInitState extends UnFollowingState{}

class UnFollowingLoadingState extends UnFollowingState{}

class UnAddFollowingSuccessState extends UnFollowingState{}

class UnAddFollowingErrorState extends UnFollowingState{
  final String message;
  UnAddFollowingErrorState( {required this.message});
}
