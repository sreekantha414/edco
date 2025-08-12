import 'package:award_maker/Screens/Settings/Repository/notification_toggle_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../../SignUpScreen/Model/SignUpModel.dart';
import '../Model/ToggleNotificationModel.dart';

part 'notification_toggle_event.dart';
part 'notification_toggle_state.dart';

class NotificationToggleBloc extends Bloc<NotificationToggleEvent, NotificationToggleState> {
  final _repository = GetIt.I<NotificationToggleRepository>();

  NotificationToggleBloc() : super(NotificationToggleState()) {
    on<PerformNotificationToggleEvent>(_signUp);
  }

  void _signUp(PerformNotificationToggleEvent event, Emitter<NotificationToggleState> emit) async {
    emit(NotificationToggleState(isLoading: true, isMoreLoading: false));

    final response = await _repository.notificationToggle(event.data);
    print('RESPONSE_STATUS ${response.status}');
    // log('event data -> ');
    if (response.status == ApiStatus.success) {
      emit(NotificationToggleState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        NotificationToggleState(
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
