import 'package:award_maker/Screens/LoginScreen/Model/LoginModel.dart';

import '../../../../api_models/api_response.dart';
import '../../DrawerScreen/Model/edit_profile_model.dart';

abstract class ChangePasswordRepository {
  Future<ApiResponse<EditProfileModel>> forgotPassword(String? id, dynamic data);
}
