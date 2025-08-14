import 'package:award_maker/Screens/SearchScreen/Repository/search_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../HomeScreen/Model/AwardListModel.dart';
import '../Model/SearchModel.dart';

class SearchRepositoryImpl extends SearchRepository {
  final _dio = GetIt.I<Dio>();
  final logger = Logger();

  @override
  Future<ApiResponse<SearchModel>> search(query, page) async {
    try {
      final response = await _dio.get('${APIConstants.search}?page=$page&search=$query&limit=10');

      print('Response -> ${response.data}');
      logger.i(response.data);
      final newsResponse = SearchModel.fromJson(response.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.success(data: newsResponse);
    } on DioException catch (error) {
      logger.e('MY_ERROR $error');
      final response = error.response;
      print('Error Data $error');
      print('Error Data $response');

      final newsResponse = SearchModel.fromJson(response?.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.error(data: newsResponse);
    }
  }
}
