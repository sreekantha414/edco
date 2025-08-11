import 'package:award_maker/Screens/AwardDetailScreen/Repository/award_detail_repo_impl.dart';
import 'package:award_maker/Screens/Categories/Repository/categories_repo_impl.dart';
import 'package:award_maker/Screens/Change%20Password/Repository/change_password_repo_impl.dart';
import 'package:award_maker/Screens/HomeScreen/Repository/award_list_repo.dart';
import 'package:award_maker/Screens/HomeScreen/Repository/set_favorite_repo_impl.dart';
import 'package:award_maker/Screens/LoginScreen/Repository/forgot_password_repo_impl.dart';
import 'package:award_maker/Screens/Notification/Repository/notification_repo_impl.dart';
import 'package:award_maker/Screens/OtpScreen/Repository/resend_otp_repo_impl.dart';
import 'package:award_maker/Screens/OtpScreen/Repository/verify_otp_repo_impl.dart';
import 'package:award_maker/Screens/Settings/Repository/notification_toggle_repo_impl.dart';
import 'package:award_maker/Screens/SignUpScreen/Repository/check_email_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import '../Screens/AwardDetailScreen/Repository/award_detail_repo.dart';
import '../Screens/Categories/Repository/categories_repo.dart';
import '../Screens/Change Password/Repository/change_password_repo.dart';
import '../Screens/DrawerScreen/Repository/edit_profile_repo.dart';
import '../Screens/DrawerScreen/Repository/edit_profile_repo_impl.dart';
import '../Screens/HomeScreen/Repository/award_list_repo_impl.dart';
import '../Screens/HomeScreen/Repository/favorite_list_repo.dart';
import '../Screens/HomeScreen/Repository/favorite_list_repo_impl.dart';
import '../Screens/HomeScreen/Repository/set_favorite_repo.dart';
import '../Screens/LoginScreen/Repository/forgot_password_repo.dart';
import '../Screens/LoginScreen/Repository/login_repo.dart';
import '../Screens/LoginScreen/Repository/login_repo_impl.dart';
import '../Screens/Notification/Repository/notification_repo.dart';
import '../Screens/OtpScreen/Repository/resend_otp_repo.dart';
import '../Screens/OtpScreen/Repository/verify_otp_repo.dart';
import '../Screens/Settings/Repository/notification_toggle_repo.dart';
import '../Screens/SignUpScreen/Repository/check_email_repo.dart';
import '../Screens/SignUpScreen/Repository/sign_up_repo.dart';
import '../Screens/SignUpScreen/Repository/sign_up_repo_impl.dart';
import '../api_client/dio_client.dart';

final GetIt _getIt = GetIt.instance;

void setupDependencies() {
  // Logger
  _getIt.registerSingleton<Logger>(Logger());
  // DIO HTTP Client
  _getIt.registerSingleton<Dio>(DioClient().getDio());

  //Login
  _getIt.registerSingleton<LoginRepository>(LoginRepositoryImpl());
  _getIt.registerSingleton<AwardListRepository>(AwardListRepositoryImpl());
  _getIt.registerSingleton<SignUpRepository>(SignUpRepositoryImpl());
  _getIt.registerSingleton<CategoriesRepository>(CategoriesRepositoryImpl());
  _getIt.registerSingleton<VerifyOtpRepository>(VerifyOtpRepositoryImpl());
  _getIt.registerSingleton<ReSendOtpRepository>(ReSendOtpRepositoryImpl());
  _getIt.registerSingleton<ForgotPasswordRepository>(ForgotPasswordRepositoryImpl());
  _getIt.registerSingleton<NotificationToggleRepository>(NotificationToggleRepositoryImpl());
  _getIt.registerSingleton<NotificationListRepository>(NotificationListRepositoryImpl());
  _getIt.registerSingleton<EditProfileRepository>(EditProfileRepositoryImpl());
  _getIt.registerSingleton<SetFavoriteRepository>(SetFavoriteRepositoryImpl());
  _getIt.registerSingleton<FavoriteListRepository>(FavoriteListRepositoryImpl());
  _getIt.registerSingleton<AwardDetailRepository>(AwardDetailRepositoryImpl());
  _getIt.registerSingleton<ChangePasswordRepository>(ChangePasswordRepositoryImpl());
  _getIt.registerSingleton<CheckEmailRepository>(CheckEmailRepositoryImpl());
}
