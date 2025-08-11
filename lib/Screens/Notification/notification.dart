import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/DrawerScreen/drawer_screen.dart';
import 'package:award_maker/Screens/Notification/Bloc/notification_list_bloc.dart';
import 'package:award_maker/Screens/Notification/Model/NotificationList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/asset_path.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  BehaviorSubject<List<Data>> notificationList = BehaviorSubject<List<Data>>.seeded([]);
  ScrollController _controller = ScrollController();
  bool isLoadMoreRunningFP = false;
  bool hasNextPageNewFP = true;
  bool areAllSelected = false;
  bool hasNextPageUP = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _loadMoreStudent();
    });
    getNotification(page, '');
  }

  void _loadMoreStudent() async {
    print('Load more Up function');
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      bool isInternet = await AppUtils.checkInternet();
      if (isInternet) {
        if (hasNextPageNewFP == true) {
          print('API CALL UPCOMING ${page}');
          isLoadMoreRunningFP = true;
          getNotification(page, 'pagination');
          isLoadMoreRunningFP = false;
        } else {
          print('API CALL UPCOMING NO PAGE $page');
        }
      } else {
        AlertUtils.showNotInternetDialogue(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),

        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'NOTIFICATIONS',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18, fontFamily: "Poppins_Bold"),
          ),
        ),
      ),
      body: BlocConsumer<NotificationListBloc, NotificationListState>(
        listener: (context, notificationListState) {
          if (notificationListState.isCompleted) {
            if (notificationListState.model?.result?.data?.isNotEmpty == true) {
              if (page == 1) {
                if (notificationList.hasValue) {
                  notificationList.value.clear();
                  notificationList.add(notificationListState.model?.result?.data ?? []);
                }
              } else {
                notificationList.value.addAll(notificationListState.model?.result?.data ?? []);
              }
              print('PAGE IS INCREASED == >');
              page++;
              hasNextPageUP = true;
            } else {
              hasNextPageUP = false;
            }
          } else if (notificationListState.isFailed) {
            AlertUtils.showToast(notificationListState.responseMsg ?? '', context, AnimatedSnackBarType.error);
          }
        },
        builder: (context, notificationListState) {
          return StreamBuilder<List<Data>>(
            stream: notificationList,
            builder: (context, notificationListSnapshot) {
              return notificationListSnapshot.data?.isEmpty == true
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _controller,
                          itemCount: notificationListSnapshot.data?.length ?? 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemBuilder: (context, index) {
                            final item = notificationListSnapshot.data?[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFFFDFBF9), borderRadius: BorderRadius.circular(16)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: item?.imageName ?? '',
                                      height: 50.h,
                                      fit: BoxFit.contain,
                                      errorWidget: (context, url, error) => Image.asset(ImageAssetPath.silverCup),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item?.imageName ?? '',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(item?.createdAt ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (notificationListState.isMoreLoading == true)
                        Center(
                          child: Container(
                            height: 50.h,
                            alignment: Alignment.bottomCenter,
                            color: Colors.white,
                            child: CircularProgressIndicator(color: AppColors.blue),
                          ),
                        ),
                    ],
                  );
            },
          );
        },
      ),
    );
  }

  Future<void> getNotification(int? page, String? tag) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<NotificationListBloc>(context).add(PerformNotificationListEvent(page: page, tag: tag));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
