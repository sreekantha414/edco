import 'package:award_maker/Screens/LoginScreen/Repository/login_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_error.dart';
import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../Model/LoginModel.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _repository = GetIt.I<LoginRepository>();

  LoginBloc() : super(LoginState()) {
    on<PerformLoginEvent>(_login);
  }

  void _login(PerformLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginState(isLoading: true, isMoreLoading: false));

    final response = await _repository.login(event.data);
    print('RESPONSE_STATUS ${response.status}');
    // log('event data -> ');
    if (response.status == ApiStatus.success) {
      emit(LoginState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        LoginState(
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
