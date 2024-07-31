import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class SearchPostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends SearchPostEvent {}
class SearchQueryChanged extends SearchPostEvent {
  final String keyword;

  SearchQueryChanged(this.keyword);

  @override
  List<Object> get props => [keyword];
}