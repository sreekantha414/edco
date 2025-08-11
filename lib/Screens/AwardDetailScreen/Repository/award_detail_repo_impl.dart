import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../Model/AwardDetailModel.dart';
import 'award_detail_repo.dart';

class AwardDetailRepositoryImpl extends AwardDetailRepository {
  final _dio = GetIt.I<Dio>();
  final logger = Logger();

  @override
  Future<ApiResponse<AwardDetailModel>> awardDetail(id) async {
    try {
      final response = await _dio.get('${APIConstants.awardDetail}/$id');

      print('Response -> ${response.data}');
      logger.i(response.data);
      final newsResponse = AwardDetailModel.fromJson(response.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.success(data: newsResponse);
    } on DioException catch (error) {
      logger.e('MY_ERROR $error');
      final response = error.response;
      print('Error Data $error');
      logger.e(response?.data['message']);
      final newsResponse = AwardDetailModel.fromJson(response?.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.error(errorMsg: response?.data['message']);
    }
  }
}
