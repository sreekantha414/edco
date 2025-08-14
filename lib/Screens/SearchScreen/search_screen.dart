import 'package:award_maker/Screens/SearchScreen/Bloc/search_bloc.dart';
import 'package:award_maker/constants/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/alert_utils.dart';
import '../../utils/app_utils.dart';
import '../HomeScreen/Model/AwardListModel.dart';
import 'Model/SearchModel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BehaviorSubject<List<SearchList>> awardList = BehaviorSubject<List<SearchList>>.seeded([]);
  final ScrollController _scrollController = ScrollController();

  String searchQuery = "";
  int page = 1;
  bool hasNextPage = true;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    awardList.close();
    super.dispose();
  }

  Future<void> search(String query, {int page = 1}) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<SearchBloc>(context).add(PerformSearchEvent(query: query, page: page));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  void _loadMore() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (isLoadingMore || !hasNextPage) return;

      bool isInternet = await AppUtils.checkInternet();
      if (!isInternet) {
        AlertUtils.showNotInternetDialogue(context);
        return;
      }

      isLoadingMore = true;
      page++;
      search(searchQuery, page: page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, searchState) {
            if (searchState.isCompleted) {
              final awards = searchState.model?.result?.data ?? [];

              if (page == 1) {
                awardList.add(awards);
              } else {
                awardList.add([...awardList.value, ...awards]);
              }

              hasNextPage = awards.isNotEmpty;
              isLoadingMore = false;
            }
          },
          builder: (context, searchState) {
            return SafeArea(
              child: Container(
                height: 56.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
                    const Icon(Icons.search, color: Colors.black),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                          if (value.isNotEmpty) {
                            page = 1;
                            hasNextPage = true;
                            search(value, page: 1);
                          } else {
                            awardList.add([]);
                          }
                        },
                        style: TextStyle(fontSize: 14.sp),
                        decoration: const InputDecoration(
                          hintText: "search by name, description",
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                      ),
                    ),
                    if (searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => searchQuery = '');
                          awardList.add([]);
                        },
                        child: const Icon(Icons.close, color: Colors.red),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder<List<SearchList>>(
        stream: awardList.stream,
        builder: (context, snapshot) {
          final data = snapshot.data ?? [];

          if (searchQuery.isEmpty) {
            return _buildNoDataView();
          }

          if (data.isEmpty) {
            return _buildNoDataView();
          }

          return ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.only(top: 12.h),
            itemCount: data.length + (isLoadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              if (index == data.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final item = data[index];
              return ListTile(
                leading: Image.network(item.imageUrl ?? "", height: 40.h, width: 40.w, fit: BoxFit.cover),
                title: Text(item.imageName ?? "", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                subtitle: Text(item.categoryData?.categoryName ?? "", style: TextStyle(fontSize: 12.5.sp, color: Colors.grey.shade600)),
                onTap: () {
                  Navigator.pop(context, item.categoryData);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImageAssetPath.noData, height: 160.h),
          SizedBox(height: 16.h),
          Text('No Data Found', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
