import 'package:award_maker/Screens/Categories/Model/CategoriesModel.dart';

import '../../../../api_models/api_response.dart';

abstract class CategoriesRepository {
  Future<ApiResponse<CategoriesModel>> categories();
}
