import 'package:equatable/equatable.dart';

class FollowingState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class FollowingInitState extends FollowingState{}

class FollowingLoadingState extends FollowingState{}

class AddFollowingSuccessState extends FollowingState{}

class AddFollowingErrorState extends FollowingState{
  final String message;
  AddFollowingErrorState( {required this.message});
}
