import 'package:award_maker/Screens/Categories/Model/CategoriesModel.dart';
import 'package:award_maker/Screens/Categories/Repository/categories_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../api_models/api_response.dart';
import '../../../api_models/api_status.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final _repository = GetIt.I<CategoriesRepository>();

  CategoriesBloc() : super(CategoriesState()) {
    on<PerformCategoriesEvent>(_getCategories);
  }

  void _getCategories(PerformCategoriesEvent event, Emitter<CategoriesState> emit) async {
    emit(CategoriesState(isLoading: true, isMoreLoading: false));

    final response = await _repository.categories();
    print('RESPONSE_STATUS ${response.status}');
    // log('event data -> ');
    if (response.status == ApiStatus.success) {
      emit(CategoriesState(responseMsg: '', isLoading: false, isCompleted: true, model: response.data));
    } else {
      emit(
        CategoriesState(
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
