import 'package:award_maker/Screens/LoginScreen/Model/LoginModel.dart';

import '../../../../api_models/api_response.dart';

abstract class LoginRepository {
  Future<ApiResponse<LoginModel>> login(dynamic data);
}
