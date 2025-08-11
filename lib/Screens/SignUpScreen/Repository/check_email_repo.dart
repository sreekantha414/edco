import '../../../../api_models/api_response.dart';
import '../../LoginScreen/Model/LoginModel.dart';
import '../Model/SignUpModel.dart';

abstract class CheckEmailRepository {
  Future<ApiResponse<SignUpModel>> checkEmail(String? data);
}
