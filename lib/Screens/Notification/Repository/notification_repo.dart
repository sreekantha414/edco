import '../../../../api_models/api_response.dart';
import '../../LoginScreen/Model/LoginModel.dart';
import '../../SignUpScreen/Model/SignUpModel.dart';
import '../Model/NotificationList.dart';

abstract class NotificationListRepository {
  Future<ApiResponse<NotificationList>> notificationList(int? page);
}
