import 'package:equatable/equatable.dart';

class EditProfileState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class EditProfileInitState extends EditProfileState{}

class EditProfileLoadingState extends EditProfileState{}

class EditProfileSuccessState extends EditProfileState{}

class EditProfileErrorState extends EditProfileState{
  final String message;
  EditProfileErrorState( {required this.message});
}
