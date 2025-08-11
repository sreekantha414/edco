import 'package:award_maker/Screens/AwardDetailScreen/Model/AwardDetailModel.dart';
import '../../../../api_models/api_response.dart';

abstract class AwardDetailRepository {
  Future<ApiResponse<AwardDetailModel>> awardDetail(String? id);
}
