import 'package:award_maker/Screens/HomeScreen/Model/FavoriteListModel.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_error.dart';
import '../../../api_models/api_status.dart';
import '../Model/AwardListModel.dart';
import '../Repository/favorite_list_repo.dart';

part 'favorite_list_event.dart';
part 'favorite_list_state.dart';

class FavoriteListBloc extends Bloc<FavoriteListEvent, FavoriteListState> {
  final _repository = GetIt.I<FavoriteListRepository>();

  FavoriteListBloc() : super(FavoriteListState()) {
    on<PerformFavoriteListEvent>(_favoriteList);
  }

  void _favoriteList(PerformFavoriteListEvent event, Emitter<FavoriteListState> emit) async {
    if (event.pagination == 'pagination') {
      emit(FavoriteListState(isMoreLoading: true, isFailed: false, isLoading: false));
    } else {
      emit(FavoriteListState(isLoading: true, isMoreLoading: false));
    }
    final response = await _repository.favoriteList(event.page, event.cid);
    print('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      emit(FavoriteListState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        FavoriteListState(
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
