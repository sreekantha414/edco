import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../Model/SignUpModel.dart';
import '../Repository/check_email_repo.dart';

part 'check_email_event.dart';
part 'check_email_state.dart';

class CheckEmailBloc extends Bloc<CheckEmailEvent, CheckEmailState> {
  final _repository = GetIt.I<CheckEmailRepository>();

  CheckEmailBloc() : super(CheckEmailState()) {
    on<PerformCheckEmailEvent>(_signUp);
  }

  void _signUp(PerformCheckEmailEvent event, Emitter<CheckEmailState> emit) async {
    emit(CheckEmailState(isLoading: true, isMoreLoading: false));

    final response = await _repository.checkEmail(event.email);
    print('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      emit(CheckEmailState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        CheckEmailState(
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
