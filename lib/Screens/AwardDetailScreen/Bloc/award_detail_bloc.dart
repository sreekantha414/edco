import 'package:award_maker/Screens/AwardDetailScreen/Model/AwardDetailModel.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../Repository/award_detail_repo.dart';

part 'award_detail_event.dart';
part 'award_detail_state.dart';

class AwardDetailBloc extends Bloc<AwardDetailEvent, AwardDetailState> {
  final _repository = GetIt.I<AwardDetailRepository>();

  AwardDetailBloc() : super(AwardDetailState()) {
    on<PerformAwardDetailEvent>(_awardDetail);
  }

  void _awardDetail(PerformAwardDetailEvent event, Emitter<AwardDetailState> emit) async {
    emit(AwardDetailState(isLoading: true));

    final response = await _repository.awardDetail(event.id);
    print('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      emit(AwardDetailState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        AwardDetailState(
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
