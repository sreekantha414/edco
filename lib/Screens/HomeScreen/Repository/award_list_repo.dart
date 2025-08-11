import '../../../../api_models/api_response.dart';
import '../Model/AwardListModel.dart';

abstract class AwardListRepository {
  Future<ApiResponse<AwardListModel>> getList(String? id, int? page, String? tag);
}
