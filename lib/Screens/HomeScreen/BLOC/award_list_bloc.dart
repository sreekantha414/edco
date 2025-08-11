import 'package:award_maker/Screens/HomeScreen/Repository/award_list_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_error.dart';
import '../../../api_models/api_status.dart';
import '../Model/AwardListModel.dart';

part 'award_list_event.dart';
part 'award_list_state.dart';

class AwardListBloc extends Bloc<AwardListEvent, AwardListState> {
  final _repository = GetIt.I<AwardListRepository>();

  AwardListBloc() : super(AwardListState()) {
    on<PerformAwardListEvent>(_departmentList);
  }

  void _departmentList(PerformAwardListEvent event, Emitter<AwardListState> emit) async {
    if (event.pagination == 'pagination') {
      emit(AwardListState(isMoreLoading: true, isFailed: false, isLoading: false));
    } else {
      emit(AwardListState(isLoading: true, isMoreLoading: false));
    }

    final response = await _repository.getList(event.id, event.page, event.tag);
    print('RESPONSE_STATUS ${response.status}');
    // log('event data -> ');
    if (response.status == ApiStatus.success) {
      emit(AwardListState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        AwardListState(
          error: response.error,
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
