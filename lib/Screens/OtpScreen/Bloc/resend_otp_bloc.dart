import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../../LoginScreen/Model/LoginModel.dart';
import '../Repository/resend_otp_repo.dart';

part 'resend_otp_event.dart';
part 'resend_otp_state.dart';

class ResendOtpBloc extends Bloc<ResendOtpEvent, ResendOtpState> {
  final _repository = GetIt.I<ReSendOtpRepository>();

  ResendOtpBloc() : super(ResendOtpState()) {
    on<PerformResendOtpEvent>(_reSendOtp);
  }

  void _reSendOtp(PerformResendOtpEvent event, Emitter<ResendOtpState> emit) async {
    emit(ResendOtpState(isLoading: true, isMoreLoading: false));

    final response = await _repository.reSendOtp(event.id, event.data);
    print('RESPONSE_STATUS ${response.status}');
    // log('event data -> ');
    if (response.status == ApiStatus.success) {
      emit(ResendOtpState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        ResendOtpState(
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
