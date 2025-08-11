import 'dart:convert';

import 'package:award_maker/Screens/DrawerScreen/Model/edit_profile_model.dart';
import 'package:award_maker/Screens/LoginScreen/Model/LoginModel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../../../../api_client/api_constans.dart';
import '../../../../api_models/api_response.dart';
import '../../Categories/Model/CategoriesModel.dart';
import 'edit_profile_repo.dart';

class EditProfileRepositoryImpl extends EditProfileRepository {
  final _dio = GetIt.I<Dio>();
  final logger = Logger();

  @override
  Future<ApiResponse<EditProfileModel>> editProfile(id, data) async {
    try {
      final response = await _dio.patch('${APIConstants.editProfile}/$id', data: data);

      print('Response -> ${response.data}');
      logger.i(response.data);
      final newsResponse = EditProfileModel.fromJson(response.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.success(data: newsResponse);
    } on DioException catch (error) {
      logger.e('MY_ERROR $error');
      final response = error.response;
      print('Error Data $error');
      logger.e(response?.data['message']);
      final newsResponse = EditProfileModel.fromJson(response?.data);
      print("New Response -> : $newsResponse");
      return ApiResponse.error(errorMsg: response?.data['message']);
    }
  }
}
