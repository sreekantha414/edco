import 'dart:convert';

import 'package:award_maker/Screens/LoginScreen/Model/LoginModel.dart';
import 'package:award_maker/Screens/OtpScreen/Repository/verify_otp_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../Model/VerifyOtpModel.dart';

class VerifyOtpRepositoryImpl extends VerifyOtpRepository {
  final _dio = GetIt.I<Dio>();
  final logger = Logger();

  @override
  Future<ApiResponse<VerifyOtpModel>> verifyOtp(id, data) async {
    try {
      final response;
      if (id?.isNotEmpty == true || id != null) {
        ///Email verify
        response = await _dio.patch('${APIConstants.verifyOtp}/$id', data: data);
      } else {
        response = await _dio.patch(APIConstants.passwordVerify, data: data);
      }

      print('Response -> ${response.data}');
      logger.i(response.data);
      final newsResponse = VerifyOtpModel.fromJson(response.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.success(data: newsResponse);
    } on DioException catch (error) {
      logger.e('MY_ERROR $error');
      final response = error.response;
      print('Error Data $error');
      logger.e(response?.data['message']);
      final newsResponse = VerifyOtpModel.fromJson(response?.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.error(errorMsg: response?.data['message']);
    }
  }
}
