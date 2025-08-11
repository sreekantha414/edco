import '../../../../api_models/api_response.dart';
import '../Model/VerifyOtpModel.dart';

abstract class VerifyOtpRepository {
  Future<ApiResponse<VerifyOtpModel>> verifyOtp(String? id, dynamic data);
}
