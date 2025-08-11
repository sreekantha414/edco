import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../../LoginScreen/Model/LoginModel.dart';
import '../Model/VerifyOtpModel.dart';
import '../Repository/verify_otp_repo.dart';

part 'verify_otp_event.dart';
part 'verify_otp_state.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final _repository = GetIt.I<VerifyOtpRepository>();

  VerifyOtpBloc() : super(VerifyOtpState()) {
    on<PerformVerifyOtpEvent>(_verifyOtp);
  }

  void _verifyOtp(PerformVerifyOtpEvent event, Emitter<VerifyOtpState> emit) async {
    emit(VerifyOtpState(isLoading: true, isMoreLoading: false));

    final response = await _repository.verifyOtp(event.id, event.data);
    print('RESPONSE_STATUS ${response.status}');
    // log('event data -> ');
    if (response.status == ApiStatus.success) {
      emit(VerifyOtpState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        VerifyOtpState(
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
