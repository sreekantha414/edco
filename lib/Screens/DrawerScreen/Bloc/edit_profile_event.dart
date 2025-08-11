part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent {
  EditProfileEvent();
}

class PerformEditProfileEvent extends EditProfileEvent {
  final String? id;
  final dynamic data;
  PerformEditProfileEvent(this.id, this.data);
}
