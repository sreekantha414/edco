import 'package:award_maker/Screens/HomeScreen/BLOC/set_favorite_bloc.dart';
import 'package:award_maker/Screens/HomeScreen/Repository/set_favorite_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../Model/AwardListModel.dart';
import 'award_list_repo.dart';

class SetFavoriteRepositoryImpl extends SetFavoriteRepository {
  final _dio = GetIt.I<Dio>();
  final logger = Logger();

  @override
  Future<ApiResponse<AwardListModel>> setFavorite(data) async {
    try {
      final response = await _dio.post(APIConstants.setFavorite, data: data);

      print('Response -> ${response.data}');
      logger.i(response.data);
      final newsResponse = AwardListModel.fromJson(response.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.success(data: newsResponse);
    } on DioException catch (error) {
      logger.e('MY_ERROR $error');
      final response = error.response;
      print('Error Data $error');
      print('Error Data $response');

      final newsResponse = AwardListModel.fromJson(response?.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.error(data: newsResponse);
    }
  }
}
