import '../../../../api_models/api_response.dart';
import '../Model/FavoriteListModel.dart';

abstract class FavoriteListRepository {
  Future<ApiResponse<FavoriteListModel>> favoriteList(int? page, String? cid);
}
