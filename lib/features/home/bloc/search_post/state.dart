import 'package:equatable/equatable.dart';

class SearchPostState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class SearchPostInitState extends SearchPostState{}

class SearchPostLoadingState extends SearchPostState{}

class SearchPostSuccessState extends SearchPostState{
  final List<dynamic> results;

  SearchPostSuccessState(this.results);

  @override
  List<Object> get props => [results];
}

class SearchPostErrorState extends SearchPostState{
  final String message;
  SearchPostErrorState( {required this.message});
}
