import 'package:award_maker/Screens/LoginScreen/Model/LoginModel.dart';

import '../../../../api_models/api_response.dart';

abstract class ForgotPasswordRepository {
  Future<ApiResponse<LoginModel>> forgotPassword(dynamic data);
}
