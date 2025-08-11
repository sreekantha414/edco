import '../../../../api_models/api_response.dart';
import '../../LoginScreen/Model/LoginModel.dart';
import '../../SignUpScreen/Model/SignUpModel.dart';

abstract class NotificationToggleRepository {
  Future<ApiResponse<SignUpModel>> notificationToggle(dynamic data);
}
