import 'package:award_maker/Screens/LoginScreen/Model/LoginModel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../SignUpScreen/Model/SignUpModel.dart';
import '../Model/NotificationList.dart';
import 'notification_repo.dart';

class NotificationListRepositoryImpl extends NotificationListRepository {
  final _dio = GetIt.I<Dio>();
  final logger = Logger();

  @override
  Future<ApiResponse<NotificationList>> notificationList(page) async {
    try {
      final response = await _dio.get('${APIConstants.notificationList}?page=$page');

      print('Response -> ${response.data}');
      logger.i(response.data);
      final newsResponse = NotificationList.fromJson(response.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.success(data: newsResponse);
    } on DioException catch (error) {
      logger.e('MY_ERROR $error');
      final response = error.response;
      print('Error Data $error');
      logger.e(response?.data['message']);
      final newsResponse = NotificationList.fromJson(response?.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.error(errorMsg: response?.data['message']);
    }
  }
}
