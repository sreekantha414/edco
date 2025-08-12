import '../../../../api_models/api_response.dart';
import '../Model/ToggleNotificationModel.dart';

abstract class NotificationToggleRepository {
  Future<ApiResponse<ToggleNotificationModel>> notificationToggle(dynamic data);
}
