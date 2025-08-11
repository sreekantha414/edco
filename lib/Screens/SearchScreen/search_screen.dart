import 'package:award_maker/constants/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  final List<Map<String, String>> allItems = const [
    {"title": "Notched Corner Rosewood Plaque", "subtitle": "Plaque Awards", "image": "assets/download.jpeg"},
    {"title": "Hand Shake Award", "subtitle": "Trophy Awards", "image": "assets/download.jpeg"},
    {"title": "Hera Art Glass Vase", "subtitle": "Art Glass Awards", "image": "assets/download.jpeg"},
    {"title": "Synergy Flame Crystal", "subtitle": "Art Glass Awards", "image": "assets/download.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems =
        searchQuery.isEmpty ? [] : allItems.where((item) => item['title']!.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.h),
        child: SafeArea(
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
                    },
                    style: TextStyle(fontSize: 14.sp),
                    decoration: const InputDecoration(hintText: "search by name,description", border: InputBorder.none, isCollapsed: true),
                  ),
                ),
                if (searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => searchQuery = '');
                    },
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
      body:
          searchQuery.isEmpty || filteredItems.isEmpty
              ? _buildNoDataView()
              : ListView.separated(
                padding: EdgeInsets.only(top: 12.h),
                itemCount: filteredItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ListTile(
                    leading: Image.asset(item['image']!, height: 40.h, width: 40.w, fit: BoxFit.cover),
                    title: Text(item['title']!, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                    subtitle: Text(item['subtitle']!, style: TextStyle(fontSize: 12.5.sp, color: Colors.grey.shade600)),
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
