import 'package:equatable/equatable.dart';

class AddPostState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddPostInitState extends AddPostState{}

class AddPostLoadingState extends AddPostState{}

class AddPostSuccessState extends AddPostState{}

class AddPostErrorState extends AddPostState{
  final String message;
  AddPostErrorState( {required this.message});
}
