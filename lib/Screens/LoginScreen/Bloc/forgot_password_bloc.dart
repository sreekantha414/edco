import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../Model/LoginModel.dart';
import '../Repository/forgot_password_repo.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final _repository = GetIt.I<ForgotPasswordRepository>();

  ForgotPasswordBloc() : super(ForgotPasswordState()) {
    on<PerformForgotPasswordEvent>(_forgotPassword);
  }

  void _forgotPassword(PerformForgotPasswordEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordState(isLoading: true, isMoreLoading: false));

    final response = await _repository.forgotPassword(event.data);
    print('RESPONSE_STATUS ${response.status}');
    // log('event data -> ');
    if (response.status == ApiStatus.success) {
      emit(ForgotPasswordState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        ForgotPasswordState(
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
