import '../../../../api_models/api_response.dart';
import '../../LoginScreen/Model/LoginModel.dart';
import '../Model/SignUpModel.dart';

abstract class SignUpRepository {
  Future<ApiResponse<SignUpModel>> signUp(dynamic data);
}
