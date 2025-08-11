import 'package:award_maker/Screens/LoginScreen/Repository/login_repo.dart';
import 'package:award_maker/Screens/SignUpScreen/Repository/sign_up_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_error.dart';
import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../../LoginScreen/Model/LoginModel.dart';
import '../Model/SignUpModel.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final _repository = GetIt.I<SignUpRepository>();

  SignUpBloc() : super(SignUpState()) {
    on<PerformSignUpEvent>(_signUp);
  }

  void _signUp(PerformSignUpEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpState(isLoading: true, isMoreLoading: false));

    final response = await _repository.signUp(event.data);
    print('RESPONSE_STATUS ${response.status}');
    // log('event data -> ');
    if (response.status == ApiStatus.success) {
      emit(SignUpState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        SignUpState(
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
