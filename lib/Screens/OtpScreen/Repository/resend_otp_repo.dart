import 'package:award_maker/Screens/LoginScreen/Model/LoginModel.dart';

import '../../../../api_models/api_response.dart';

abstract class ReSendOtpRepository {
  Future<ApiResponse<LoginModel>> reSendOtp(String? id, dynamic data);
}
