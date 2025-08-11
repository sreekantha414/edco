import 'package:award_maker/Screens/Categories/Model/CategoriesModel.dart';

import '../../../../api_models/api_response.dart';
import '../Model/edit_profile_model.dart';

abstract class EditProfileRepository {
  Future<ApiResponse<EditProfileModel>> editProfile(String? id, dynamic data);
}
