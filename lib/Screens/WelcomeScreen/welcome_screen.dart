import 'package:award_maker/Screens/LoginScreen/login_screen.dart';
import 'package:award_maker/Widget/app_button.dart';
import 'package:award_maker/constants/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/wk1.png',
      'title': 'Customized Award Images',
      'desc': 'You have the choice to create your own personalized certificate and share it',
    },
    {
      'image': 'assets/images/wk3.png',
      'title': 'EDIT AND SHARE',
      'desc': 'Download certificates to your gallery or share directly with others',
    },
    {
      'image': 'assets/images/wk2.png',
      'title': 'CHANGE TEXT COLOR AND SIZE',
      'desc': 'Just a few taps and your customized certificate is ready to go!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(child: Image.asset(ImageAssetPath.wkback, fit: BoxFit.cover)),

          Column(
            children: [
              // Top 55%: Image + Dots
              SizedBox(height: 40.h),
              SizedBox(
                height: height * 0.55,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Image.asset(pages[index]['image']!, height: 350.h, fit: BoxFit.contain), const SizedBox(height: 30)],
                    );
                  },
                ),
              ),

              // Bottom 45%: Text + Button
              Expanded(
                child: Container(
                  height: height * 0.45,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Dot indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == i ? 12 : 8,
                            height: _currentIndex == i ? 12 : 8,
                            decoration: BoxDecoration(color: _currentIndex == i ? Colors.blue : Colors.grey[300], shape: BoxShape.circle),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),

                      Text(pages[_currentIndex]['title']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(
                        pages[_currentIndex]['desc']!,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),

                      Spacer(), // Get Started button
                      AppButton(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        buttonName: 'Get tarted',
                        buttonColor: Colors.blue,
                        style: TextStyle(fontSize: 16.sp, color: Colors.white, fontFamily: "Poppins_Bold"),
                        onPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
