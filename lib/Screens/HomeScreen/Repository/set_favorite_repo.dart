import '../../../../api_models/api_response.dart';
import '../Model/AwardListModel.dart';

abstract class SetFavoriteRepository {
  Future<ApiResponse<AwardListModel>> setFavorite(dynamic data);
}
