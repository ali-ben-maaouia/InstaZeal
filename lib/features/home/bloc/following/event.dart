import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class FollowingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends FollowingEvent {}
class addFollowingbuttonpressed extends FollowingEvent{
  final int id;
  addFollowingbuttonpressed({ required this.id});
}