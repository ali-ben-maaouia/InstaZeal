import 'package:equatable/equatable.dart';

class StoryState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class StoryInitState extends StoryState{}

class StoryLoadingState extends StoryState{}

class AddStorySuccessState extends StoryState{}

class AddStoryErrorState extends StoryState{
  final String message;
  AddStoryErrorState( {required this.message});
}
