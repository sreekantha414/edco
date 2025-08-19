import 'dart:async';
import 'dart:io';

import 'package:award_maker/Screens/AwardDetailScreen/Bloc/award_detail_bloc.dart';
import 'package:award_maker/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Widget/cirlce_button_widget.dart';
import '../../constants/asset_path.dart';
import '../../utils/alert_utils.dart';
import '../../utils/app_utils.dart';
import '../AwardEditor/award_editor.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import '../HomeScreen/BLOC/set_favorite_bloc.dart';

class AwardDetailPage extends StatefulWidget {
  final String? imageID;
  const AwardDetailPage({super.key, this.imageID});

  @override
  State<AwardDetailPage> createState() => _AwardDetailPageState();
}

class _AwardDetailPageState extends State<AwardDetailPage> with SingleTickerProviderStateMixin {
  bool _showDescription = false;

  late SharedPreferences prefs;
  String? uid;

  AwardEditData? editedData;

  @override
  void initState() {
    super.initState();
    _initData();
    getAwardDetails(widget.imageID);
  }

  Future<void> _initData() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AwardDetailBloc, AwardDetailState>(
      listener: (context, awardDetailState) {},
      builder: (context, awardDetailState) {
        final imageUrl = awardDetailState.model?.result?.first.imageUrl ?? '';
        final webUrl = awardDetailState.model?.result?.first.webUrl ?? 'https://www.edco.com/searchresults?q=award';
        final imageName = awardDetailState.model?.result?.first.imageName ?? '';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: const BackButton(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              awardDetailState.model?.result?.first.imageName ?? '',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 320),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 500,
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 0)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            awardDetailState.isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorWidget: (context, url, error) => Image.asset(ImageAssetPath.silverCup),
                                  ),
                            if (editedData != null && editedData!.text.isNotEmpty)
                              Positioned(
                                left: _scaleX(editedData!.position.dx),
                                top: _scaleY(editedData!.position.dy),
                                child: Text(
                                  editedData!.text,
                                  style: TextStyle(
                                    color: editedData!.color,
                                    fontSize: editedData!.fontSize,
                                    fontWeight: editedData!.isBold ? FontWeight.bold : FontWeight.normal,
                                    fontStyle: editedData!.isItalic ? FontStyle.italic : FontStyle.normal,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push<AwardEditData?>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AwardEditor(
                                        imageUrl: imageUrl,
                                        initialData: editedData,
                                        imageName: imageName,
                                      )),
                            );

                            if (result != null) {
                              setState(() {
                                editedData = result;
                              });
                            }
                          },
                          child: const CircleIcon(icon: Icons.edit),
                        ),
                        BlocConsumer<SetFavoriteBloc, SetFavoriteState>(
                          listener: (context, setFavoriteState) {
                            if (setFavoriteState.isCompleted) {
                              getAwardDetails(widget.imageID);
                            }
                          },
                          builder: (context, setFavoriteState) {
                            return GestureDetector(
                                onTap: () {
                                  final bool currentFav = awardDetailState.model?.result?.first.favourite ?? false;
                                  final body = {
                                    "favourite": !currentFav,
                                    "imageId": awardDetailState.model?.result?.first.id ?? '',
                                    "userId": uid,
                                  };
                                  setFavorite(body);
                                },
                                child: CircleIcon(
                                  icon: Icons.favorite,
                                  isLike: awardDetailState.model?.result?.first.favourite,
                                ));
                          },
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (editedData != null && editedData!.text.isNotEmpty) {
                              await shareEditedImageWithText(imageUrl, editedData!, imageName);
                            } else if (imageUrl.isNotEmpty) {
                              await shareImageFromUrl(imageUrl, imageName);
                            }
                          },
                          child: const CircleIcon(icon: Icons.share),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: OutlinedButton(
                        onPressed: () async {
                          final result = await Navigator.push<AwardEditData?>(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AwardEditor(
                                      imageUrl: imageUrl,
                                      initialData: editedData,
                                      imageName: imageName,
                                    )),
                          );

                          if (result != null) {
                            setState(() {
                              editedData = result;
                            });
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0057B8)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Center(
                          child: Text(
                            'CUSTOMIZE AND SHARE YOUR AWARD IMAGE',
                            style: TextStyle(color: Color(0xFF0057B8), fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Description Tab
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _showDescription = !_showDescription);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    height: _showDescription ? 300 : 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Color(0xFF0057B8)),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: MediaQuery.of(context).size.width / 2 - 40,
                          child: CustomPaint(
                            painter: WaveTabPainter(),
                            child: Container(
                              width: 80,
                              height: 40,
                              alignment: Alignment.center,
                              child: const Text('Description', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                        if (_showDescription)
                          Padding(
                            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  awardDetailState.model?.result?.first.imageName ?? '',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  awardDetailState.model?.result?.first.imageDescription ?? '',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      openInBrowser(webUrl);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.white),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child:
                                        const Text('BUY NOW FROM EDCO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to scale X coordinate from editor screen to detail screen image
  double _scaleX(double editorX) {
    // Editor image width (approx)
    final double editorWidth = MediaQuery.of(context).size.width; // centered
    final double editorImageHeight = 350.h;

    // Detail screen image container width = full width minus margin*2 (20*2=40)
    final double detailImageWidth = MediaQuery.of(context).size.width - 100;

    // Calculate scale factor from editor width to detail image width
    // In editor, the image is centered and fit BoxFit.cover with height 350.h.
    // We can assume editor width is full screen width for this example.

    // To improve accuracy, you could fetch actual image dimensions or scale based on image aspect ratio.

    double scale = detailImageWidth / editorWidth;

    return editorX * scale + 0; // add margin from container
  }

  // Function to scale Y coordinate similarly
  double _scaleY(double editorY) {
    final double editorImageHeight = 350.h;
    final double detailImageHeight = 500; // fixed container height in detail

    double scale = detailImageHeight / editorImageHeight;

    return editorY * scale;
  }

  Future<void> openInBrowser(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> getAwardDetails(String? id) async {
    bool isInternet = await AppUtils.checkInternet();
    if (isInternet) {
      BlocProvider.of<AwardDetailBloc>(context).add(PerformAwardDetailEvent(id: id));
    } else {
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

  Future<void> shareImageFromUrl(String imageUrl, String? imageName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/shared_image.jpg';

      // Download image
      await Dio().download(imageUrl, filePath);

      // Share the image file
      await Share.shareXFiles([XFile(filePath)], text: imageName);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> shareEditedImageWithText(String imageUrl, AwardEditData data, String imageName) async {
    try {
      final image = await _loadImageFromNetwork(imageUrl);
      final pictureRecorder = ui.PictureRecorder();

      // Use image dimensions for canvas size
      final canvas = Canvas(pictureRecorder, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));

      final paint = Paint();

      // Draw the original image to canvas (full size)
      canvas.drawImage(image, Offset.zero, paint);

      // Calculate scale factors to convert editor coordinates to original image coordinates
      final screenWidth = MediaQueryData.fromWindow(ui.window).size.width;
      final editorImageHeight = 350; // fixed height used in editor screen (can be from constants)
      final detailImageWidth = screenWidth - 40; // container width with margin in detail screen
      final detailImageHeight = 500; // fixed container height in detail screen

      // Calculate scaling from editor to image for X and Y
      final scaleX = image.width / screenWidth;
      final scaleY = image.height / editorImageHeight;

      // Calculate the position on image canvas
      final dx = data.position.dx * scaleX;
      final dy = data.position.dy * scaleY;

      // Prepare TextPainter for the overlay text
      final textPainter = TextPainter(
        text: TextSpan(
          text: data.text,
          style: TextStyle(
            color: data.color,
            fontSize: data.fontSize * scaleX, // scale font size to image scale
            fontWeight: data.isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: data.isItalic ? FontStyle.italic : FontStyle.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '...',
      );

      textPainter.layout();

      // Optionally clip or reposition if text exceeds image boundaries
      double textX = dx;
      double textY = dy;

      if (textX + textPainter.width > image.width) {
        textX = image.width - textPainter.width;
      }
      if (textY + textPainter.height > image.height) {
        textY = image.height - textPainter.height;
      }

      // Draw the text at computed position on the canvas
      textPainter.paint(canvas, Offset(textX, textY));

      // Finish recording and convert to image
      final picture = pictureRecorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save file temporarily
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$imageName.png').create();
      await file.writeAsBytes(pngBytes);

      // Share the image file with text description
      await Share.shareXFiles([XFile(file.path)], text: imageName);
    } catch (e) {
      print("Error sharing edited image: $e");
    }
  }

  Future<ui.Image> _loadImageFromNetwork(String url) async {
    final completer = Completer<ui.Image>();
    final networkImage = NetworkImage(url);

    networkImage.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        completer.complete(info.image);
      }),
    );

    return completer.future;
  }
}

class WaveTabPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF0057B8);
    final path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, -10, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
