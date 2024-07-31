import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class StoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends StoryEvent {}
class addstorybuttonpressed extends StoryEvent{
  final String? description;
  final Uint8List storyImage;
  addstorybuttonpressed({ this.description,required this.storyImage});
}