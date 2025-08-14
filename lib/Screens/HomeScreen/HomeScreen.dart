import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:award_maker/Screens/AwardDetailScreen/award_details_screen.dart';
import 'package:award_maker/Screens/HomeScreen/BLOC/award_list_bloc.dart';
import 'package:award_maker/Screens/HomeScreen/BLOC/set_favorite_bloc.dart';
import 'package:award_maker/Screens/SearchScreen/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/asset_path.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_utils.dart';
import '../Categories/Bloc/categories_bloc.dart';
import '../Categories/Model/CategoriesModel.dart';
import '../Categories/categories_screen.dart';
import '../DrawerScreen/drawer_screen.dart';
import 'BLOC/favorite_list_bloc.dart';
import 'Model/AwardListModel.dart';
import 'Model/FavoriteListModel.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final BehaviorSubject<List<Categories>> categoriesList = BehaviorSubject<List<Categories>>.seeded([]);
  final BehaviorSubject<List<AwardList>> awardList = BehaviorSubject<List<AwardList>>.seeded([]);
  final BehaviorSubject<List<FavoriteList>> favoriteList = BehaviorSubject<List<FavoriteList>>.seeded([]);

  late SharedPreferences prefs;
  String? uid;
  Categories? selectedCategory;
  final ScrollController _controller = ScrollController();

  // Pagination vars for each tab
  int pageNew = 1;
  int pagePopular = 1;
  int pageFavorites = 1;

  bool hasNextPageNew = true;
  bool hasNextPagePopular = true;
  bool hasNextPageFavorites = true;

  bool isLoadingMore = false;

  final List<String> _tabTags = ["new", "popular", "favorites"];

  // Per-tab loading flags
  final List<bool> _isLoading = [true, true, true];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _resetPaginationForCurrentTab();
        _callAwardListForCurrentSelection('');
      }
    });
    _controller.addListener(_loadMore);

    _initData();
    getCategories();
    getFavoriteListForTab(1, '', 2, '');
  }

  Future<void> _initData() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    setState(() {});
  }

  void _resetPaginationForCurrentTab() {
    final tabIndex = _tabController.index;
    if (tabIndex == 0) {
      pageNew = 1;
      hasNextPageNew = true;
      awardList.add([]);
    } else if (tabIndex == 1) {
      pagePopular = 1;
      hasNextPagePopular = true;
      awardList.add([]);
    } else if (tabIndex == 2) {
      pageFavorites = 1;
      hasNextPageFavorites = true;
      favoriteList.add([]);
    }
  }

  void _loadMore() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (isLoadingMore) return;
      bool isInternet = await AppUtils.checkInternet();
      if (!isInternet) {
        AlertUtils.showNotInternetDialogue(context);
        return;
      }

      final tabIndex = _tabController.index;
      isLoadingMore = true;

      if (tabIndex == 0 && hasNextPageNew) {
        pageNew++;
        getAwardListForTab(pageNew, 'new', selectedCategory?.id?.toString(), tabIndex, 'pagination');
      } else if (tabIndex == 1 && hasNextPagePopular) {
        pagePopular++;
        getAwardListForTab(pagePopular, 'popular', selectedCategory?.id?.toString(), tabIndex, 'pagination');
      } else if (tabIndex == 2 && hasNextPageFavorites) {
        pageFavorites++;
        getFavoriteListForTab(pageFavorites, selectedCategory?.id?.toString(), tabIndex, 'pagination');
      }
      isLoadingMore = false;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    categoriesList.close();
    awardList.close();
    favoriteList.close();
    super.dispose();
  }

  Widget buildCard(int index, void Function()? onTap, {AwardList? data, FavoriteList? favData}) {
    final dynamic active = data ?? favData;

    if (active == null) {
      return Card(
        color: Colors.white,
        margin: const EdgeInsets.all(3),
        elevation: 5,
        child: SizedBox(height: 230.h, child: const Center(child: Text('No data'))),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Card(
            color: Colors.white,
            margin: const EdgeInsets.all(3),
            elevation: 5,
            child: CachedNetworkImage(
              imageUrl: active.imageUrl ?? '',
              height: 230.h,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Image.asset(ImageAssetPath.silverCup),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                final bool currentFav = active.favourite ?? false;
                final body = {"favourite": !currentFav, "imageId": active.id ?? '', "userId": uid};
                setFavorite(body);
              },
              child: Icon(
                (active.favourite ?? false) ? Icons.favorite : Icons.favorite_border,
                color: (active.favourite ?? false) ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetFavoriteBloc, SetFavoriteState>(
      listener: (context, setFavoriteState) {
        if (setFavoriteState.isCompleted) {
          _fetchForTab(_tabController.index, '');
        }
      },
      builder: (context, state) {
        return BlocConsumer<CategoriesBloc, CategoriesState>(
          listener: (context, categoriesState) {
            if (categoriesState.isCompleted) {
              final cats = categoriesState.model?.result ?? [];
              categoriesList.add(cats);
              if (cats.isNotEmpty && selectedCategory == null) {
                setState(() {
                  selectedCategory = cats.first;
                });
                _resetPaginationForCurrentTab();
                _callAwardListForCurrentSelection('');
              }
            }
          },
          builder: (context, state) {
            return StreamBuilder<List<Categories>>(
              stream: categoriesList,
              builder: (context, categoriesSnapshot) {
                return Scaffold(
                  backgroundColor: const Color(0xFFFAF7F3),
                  appBar: AppBar(
                    leading: IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 400),
                              pageBuilder: (context, animation, secondaryAnimation) => DrawerScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        icon: Icon(Icons.menu)),
                    backgroundColor: Colors.white,
                    iconTheme: const IconThemeData(color: Colors.black),
                    title: GestureDetector(
                      onTap: () async {
                        final selectedCat = await Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 400),
                            pageBuilder: (context, animation, secondaryAnimation) => CategoriesScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0), // right to left
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                        if (selectedCat != null && selectedCat is Categories) {
                          setState(() {
                            selectedCategory = selectedCat;
                          });
                          _resetPaginationForCurrentTab();
                          _callAwardListForCurrentSelection('');
                        } else {
                          setState(() {
                            selectedCategory = null;
                          });
                          _resetPaginationForCurrentTab();
                          _callAwardListForCurrentSelection('');
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            selectedCategory?.categoryName ?? 'All Categories',
                            style: TextStyle(color: Colors.black),
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () async {
                          final selectedCat = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                          if (selectedCat != null && selectedCat is Categories) {
                            setState(() {
                              selectedCategory = selectedCat;
                            });
                            _resetPaginationForCurrentTab();
                            _callAwardListForCurrentSelection('');
                          }
                        },
                        icon: const Icon(Icons.search),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () async {
                          final selectedCat = await Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
                          if (selectedCat != null && selectedCat is Categories) {
                            setState(() {
                              selectedCategory = selectedCat;
                            });
                            _resetPaginationForCurrentTab();
                            _callAwardListForCurrentSelection('');
                          } else {
                            setState(() {
                              selectedCategory = null;
                            });
                            _resetPaginationForCurrentTab();
                            _callAwardListForCurrentSelection('');
                          }
                        },
                        icon: const Icon(Icons.grid_view),
                      ),
                      const SizedBox(width: 12),
                    ],
                    bottom: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.blue,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [Tab(text: 'New'), Tab(text: 'Popular'), Tab(text: 'Favorites')],
                    ),
                  ),
                  body: BlocConsumer<FavoriteListBloc, FavoriteListState>(
                    listener: (context, favoriteListState) {
                      if (favoriteListState.isCompleted) {
                        final favData = favoriteListState.model?.result?.data ?? [];
                        if (pageFavorites == 1) {
                          favoriteList.add(favData);
                        } else {
                          favoriteList.add([...favoriteList.value, ...favData]);
                        }
                        hasNextPageFavorites = favData.isNotEmpty;
                        _isLoading[2] = false;
                      }
                    },
                    builder: (context, favoriteListState) {
                      return BlocConsumer<AwardListBloc, AwardListState>(
                        listener: (context, awardListState) {
                          if (awardListState.isCompleted) {
                            final awards = awardListState.model?.result?.data ?? [];
                            if (_tabController.index == 0 && pageNew == 1) {
                              awardList.add(awards);
                            } else if (_tabController.index == 1 && pagePopular == 1) {
                              awardList.add(awards);
                            } else {
                              awardList.add([...awardList.value, ...awards]);
                            }

                            if (_tabController.index == 0) {
                              hasNextPageNew = awards.isNotEmpty;
                            } else if (_tabController.index == 1) {
                              hasNextPagePopular = awards.isNotEmpty;
                            }

                            _isLoading[_tabController.index] = false;
                          }
                        },
                        builder: (context, awardListState) {
                          return StreamBuilder<List<AwardList>>(
                            stream: awardList,
                            builder: (context, awardListSnapshot) {
                              return StreamBuilder<List<FavoriteList>>(
                                stream: favoriteList,
                                builder: (context, favoriteListSnapshot) {
                                  return TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _buildGrid(awardListSnapshot.data ?? [], awardListSnapshot.data, isAward: true),
                                      _buildGrid(awardListSnapshot.data ?? [], awardListSnapshot.data, isAward: true),
                                      _buildGrid(favoriteListSnapshot.data ?? [], awardListSnapshot.data, isAward: false),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGrid(List<dynamic> data, List<AwardList>? awardList, {required bool isAward}) {
    if (_isLoading[_tabController.index]) {
      return const Center(child: CircularProgressIndicator());
    }
    if (data.isEmpty) {
      return const Center(child: Text("No data available"));
    }
    return GridView.builder(
      controller: _controller,
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return buildCard(
          index,
          () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AwardDetailPage(imageID: awardList?[index].id)));
          },
          data: isAward ? data[index] : null,
          favData: isAward ? null : data[index],
        );
      },
    );
  }

  Future<void> _callAwardListForCurrentSelection(String? pagination) async {
    await _fetchForTab(_tabController.index, pagination);
  }

  Future<void> _fetchForTab(int tabIndex, String? pagination) async {
    setState(() {
      _isLoading[tabIndex] = true;
    });

    if (tabIndex == 2) {
      await getFavoriteListForTab(pageFavorites, selectedCategory?.id?.toString() ?? '', tabIndex, pagination);
    } else {
      final String tag = _tabTags[tabIndex];
      final page = tabIndex == 0 ? pageNew : pagePopular;
      await getAwardListForTab(page, tag, selectedCategory?.id?.toString(), tabIndex, pagination);
    }
  }

  Future<void> getAwardListForTab(int? page, String? tag, String? id, int tabIndex, String? pagination) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<AwardListBloc>(context).add(PerformAwardListEvent(page: page, tag: tag, id: id, pagination: pagination));
    } else {
      _isLoading[tabIndex] = false;
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> getFavoriteListForTab(int? page, String? id, int tabIndex, String? pagination) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<FavoriteListBloc>(context).add(PerformFavoriteListEvent(page: page, cid: id, pagination: pagination));
    } else {
      _isLoading[tabIndex] = false;
      AlertUtils.showNotInternetDialogue(context);
    }
  }

  Future<void> setFavorite(dynamic data) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<SetFavoriteBloc>(context).add(PerformSetFavoriteEvent(data: data));
    } else {
      AlertUtils.showNotInternetDialogue(context);
    }
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
