import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../../SignUpScreen/Model/SignUpModel.dart';
import '../Model/NotificationList.dart';
import '../Repository/notification_repo.dart';

part 'notification_list_event.dart';
part 'notification_list_state.dart';

class NotificationListBloc extends Bloc<NotificationListEvent, NotificationListState> {
  final _repository = GetIt.I<NotificationListRepository>();

  NotificationListBloc() : super(NotificationListState()) {
    on<PerformNotificationListEvent>(_signUp);
  }

  void _signUp(PerformNotificationListEvent event, Emitter<NotificationListState> emit) async {
     if (event.tag == 'pagination') {
      emit(NotificationListState(isMoreLoading: true, isFailed: false, isLoading: false));
    } else {
      emit(NotificationListState(isLoading: true, isMoreLoading: false));
    }
    final response = await _repository.notificationList(event.page);
    print('RESPONSE_STATUS ${response.status}');
    // log('event data -> ');
    if (response.status == ApiStatus.success) {
      emit(NotificationListState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        NotificationListState(
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
