import '../../../../api_models/api_response.dart';
import '../../HomeScreen/Model/AwardListModel.dart';
import '../Model/SearchModel.dart';

abstract class SearchRepository {
  Future<ApiResponse<SearchModel>> search(String? query, int? page);
}
