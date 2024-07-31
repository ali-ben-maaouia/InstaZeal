import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class UnFollowingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends UnFollowingEvent {}
class addUnFollowingbuttonpressed extends UnFollowingEvent{
  final int id;
  addUnFollowingbuttonpressed({ required this.id});
}