import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../Model/AwardListModel.dart';
import '../Model/FavoriteListModel.dart';
import 'award_list_repo.dart';
import 'favorite_list_repo.dart';

class FavoriteListRepositoryImpl extends FavoriteListRepository {
  final _dio = GetIt.I<Dio>();
  final logger = Logger();

  @override
  Future<ApiResponse<FavoriteListModel>> favoriteList(page, cid) async {
    try {
      final response;
      if (cid?.isNotEmpty == true && cid != null) {
        response = await _dio.get('${APIConstants.favoriteList}?page=$page&limit=10&categoryId=$cid');
      } else {
        response = await _dio.get('${APIConstants.favoriteList}?page=$page&limit=10');
      }

      print('Response -> ${response.data}');
      logger.i(response.data);
      final newsResponse = FavoriteListModel.fromJson(response.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.success(data: newsResponse);
    } on DioException catch (error) {
      logger.e('MY_ERROR $error');
      final response = error.response;
      print('Error Data $error');
      print('Error Data $response');

      final newsResponse = FavoriteListModel.fromJson(response?.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.error(data: newsResponse);
    }
  }
}
