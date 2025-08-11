import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/Categories/Bloc/categories_bloc.dart';
import 'package:award_maker/constants/asset_path.dart';
import 'package:award_maker/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import '../../api_client/api_constans.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_utils.dart';
import 'Model/CategoriesModel.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  BehaviorSubject<List<Categories>> categoriesList = BehaviorSubject<List<Categories>>.seeded([]);

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  void dispose() {
    categoriesList.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        forceMaterialTransparency: false,
        toolbarHeight: 30.h,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        title: Text(
          'CATEGORIES',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18.sp, fontFamily: "Customize Toolbar…"),
        ),
      ),
      body: BlocConsumer<CategoriesBloc, CategoriesState>(
        listener: (context, categoriesState) {
          if (categoriesState.isCompleted) {
            categoriesList.add(categoriesState.model?.result ?? []);
          }

          // else if (categoriesState.isFailed) {
          //   AlertUtils.showToast(categoriesState.responseMsg ?? '', context, AnimatedSnackBarType.error);
          // }
        },
        builder: (context, state) {
          return StreamBuilder<List<Categories>>(
            stream: categoriesList,
            builder: (context, categoriesSnapshot) {
              return categoriesSnapshot.data?.isEmpty == true
                  ? Center(child: CircularProgressIndicator())
                  : ListView.separated(
                    itemCount: categoriesSnapshot.data?.length ?? 0,
                    separatorBuilder: (_, __) => SizedBox(height: 20.h, child: const Divider(height: 1, color: Colors.black12)),
                    itemBuilder: (context, index) {
                      final category = categoriesSnapshot.data?[index];
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: category?.categoryImage ?? '',
                          height: 40.h,
                          width: 40.w,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) => Image.asset(ImageAssetPath.silverCup),
                        ),
                        title: Text(category?.categoryName ?? '', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                        onTap: () {},
                      );
                    },
                  );
            },
          );
        },
      ),
    );
  }

  Future<void> getCategories() async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<CategoriesBloc>(context).add(PerformCategoriesEvent());
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }
}
