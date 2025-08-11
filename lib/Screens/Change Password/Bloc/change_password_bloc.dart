import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../../DrawerScreen/Model/edit_profile_model.dart';
import '../../LoginScreen/Model/LoginModel.dart';
import '../Repository/change_password_repo.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final _repository = GetIt.I<ChangePasswordRepository>();

  ChangePasswordBloc() : super(ChangePasswordState()) {
    on<PerformChangePasswordEvent>(_changePassword);
  }

  void _changePassword(PerformChangePasswordEvent event, Emitter<ChangePasswordState> emit) async {
    emit(ChangePasswordState(isLoading: true, isMoreLoading: false));

    final response = await _repository.forgotPassword(event.id, event.data);
    if (response.status == ApiStatus.success) {
      emit(ChangePasswordState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        ChangePasswordState(
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
