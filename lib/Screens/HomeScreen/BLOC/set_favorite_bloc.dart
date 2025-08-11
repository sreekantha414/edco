import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_error.dart';
import '../../../api_models/api_status.dart';
import '../Model/AwardListModel.dart';
import '../Repository/set_favorite_repo.dart';

part 'set_favorite_event.dart';
part 'set_favorite_state.dart';

class SetFavoriteBloc extends Bloc<SetFavoriteEvent, SetFavoriteState> {
  final _repository = GetIt.I<SetFavoriteRepository>();

  SetFavoriteBloc() : super(SetFavoriteState()) {
    on<PerformSetFavoriteEvent>(_setFavorite);
  }

  void _setFavorite(PerformSetFavoriteEvent event, Emitter<SetFavoriteState> emit) async {
    emit(SetFavoriteState(isLoading: true, isMoreLoading: false));

    final response = await _repository.setFavorite(event.data);
    print('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      emit(SetFavoriteState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        SetFavoriteState(
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
