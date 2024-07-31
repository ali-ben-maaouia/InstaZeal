import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class AddPostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartEvent extends AddPostEvent {}
class AddPostbuttonpressed extends AddPostEvent{
  final String? description;
  final String categoryId;
  final Uint8List PostImage;
  AddPostbuttonpressed({ this.description,required this.PostImage,required this.categoryId});
}