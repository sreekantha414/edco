import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';
import '../../HomeScreen/Model/AwardListModel.dart';
import '../Model/SearchModel.dart';
import '../Repository/search_repo.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _repository = GetIt.I<SearchRepository>();

  SearchBloc() : super(SearchState()) {
    on<PerformSearchEvent>(_search);
  }

  void _search(PerformSearchEvent event, Emitter<SearchState> emit) async {
    emit(SearchState(isLoading: true, isMoreLoading: false));

    final response = await _repository.search(event.query, event.page);
    print('RESPONSE_STATUS ${response.status}');
    if (response.status == ApiStatus.success) {
      emit(SearchState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        SearchState(
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
