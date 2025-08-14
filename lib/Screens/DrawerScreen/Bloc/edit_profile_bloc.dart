import 'package:award_maker/main.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../../Categories/Model/CategoriesModel.dart';
import '../Model/edit_profile_model.dart';
import '../Repository/edit_profile_repo.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final _repository = GetIt.I<EditProfileRepository>();

  EditProfileBloc() : super(EditProfileState()) {
    on<PerformEditProfileEvent>(_editProfile);
  }

  void _editProfile(PerformEditProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileState(isLoading: true, isMoreLoading: false));

    final response = await _repository.editProfile(event.id, event.data);
    print('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      logger.e('THIS IS CALLED');
      emit(EditProfileState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        EditProfileState(
          error: response,
          responseMsg: response.errorMsg,
          isFailed: true,
          isLoading: false,
          isCompleted: false,
          model: response.data,
        ),
      );
    }
  }
}
