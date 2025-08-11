import 'package:award_maker/constants/asset_path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AwardEditData {
  String text;
  Offset position;
  Color color;
  double fontSize;
  bool isBold;
  bool isItalic;

  AwardEditData({
    required this.text,
    required this.position,
    required this.color,
    required this.fontSize,
    required this.isBold,
    required this.isItalic,
  });
}

class AwardEditor extends StatefulWidget {
  final String? imageUrl;
  final AwardEditData? initialData;

  const AwardEditor({super.key, this.imageUrl, this.initialData});

  @override
  State<AwardEditor> createState() => _AwardEditorState();
}

class _AwardEditorState extends State<AwardEditor> {
  Offset textPosition = const Offset(100, 200);
  String inputText = "";
  Color selectedColor = Colors.purple;
  double fontSize = 20;
  bool isBold = false;
  bool isItalic = false;
  late TextEditingController _textController;

  final GlobalKey _stackKey = GlobalKey();

  void resetState() {
    setState(() {
      _textController.clear();
      inputText = "";
      textPosition = const Offset(100, 200);
      selectedColor = Colors.purple;
      fontSize = 20;
      isBold = false;
      isItalic = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    // Load initial data if exists
    if (widget.initialData != null) {
      inputText = widget.initialData!.text;
      textPosition = widget.initialData!.position;
      selectedColor = widget.initialData!.color;
      fontSize = widget.initialData!.fontSize;
      isBold = widget.initialData!.isBold;
      isItalic = widget.initialData!.isItalic;
      _textController.text = inputText;
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    final RenderBox? stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null) return;

    final localPosition = stackBox.globalToLocal(details.globalPosition);

    // Optionally clamp position inside Stack/image bounds (assuming image size known)
    final double maxX = stackBox.size.width - 10; // 10 padding from right edge
    final double maxY = stackBox.size.height - 10; // 10 padding from bottom edge

    setState(() {
      textPosition = Offset(localPosition.dx.clamp(0, maxX), localPosition.dy.clamp(0, maxY));
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void onApplyPressed() {
    if (inputText.trim().isEmpty) {
      // Maybe show toast or do nothing if no text
      return;
    }

    final data = AwardEditData(
      text: inputText,
      position: textPosition,
      color: selectedColor,
      fontSize: fontSize,
      isBold: isBold,
      isItalic: isItalic,
    );

    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('EDIT', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [Padding(padding: EdgeInsets.only(right: 16), child: Image.asset(ImageAssetPath.share, height: 28.h))],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            key: _stackKey,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl ?? '',
                  fit: BoxFit.cover,
                  height: 350.h,
                  errorWidget: (context, url, error) => Image.asset(ImageAssetPath.silverCup),
                ),
              ),
              Positioned(
                left: textPosition.dx,
                top: textPosition.dy,
                child: GestureDetector(
                  onPanUpdate: onPanUpdate,

                  // onPanUpdate: (details) {
                  //   setState(() {
                  //     textPosition += details.delta;
                  //   });
                  // },
                  child: Text(
                    inputText,
                    style: TextStyle(
                      color: selectedColor,
                      fontSize: fontSize,
                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // COLOR SLIDER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 20,
                trackShape: HueGradientTrackShape(),
                thumbColor: Colors.white,
                overlayColor: selectedColor.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
              ),
              child: Slider(
                min: 0,
                max: 360,
                value: HSVColor.fromColor(selectedColor).hue,
                onChanged: (value) {
                  setState(() {
                    selectedColor = HSVColor.fromAHSV(1.0, value, 1.0, 1.0).toColor();
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // SIZE SLIDER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text("A"),
                Expanded(
                  child: Slider(
                    min: 10,
                    max: 50,
                    value: fontSize,
                    onChanged: (value) {
                      setState(() {
                        fontSize = value;
                      });
                    },
                  ),
                ),
                Text("A", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 25.h),

          // TEXT INPUT + BOLD / ITALIC
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: (value) {
                      setState(() {
                        inputText = value;
                      });
                    },
                    decoration: const InputDecoration(hintText: 'Enter your text', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                ToggleButton(
                  label: 'B',
                  isActive: isBold,
                  onTap: () {
                    setState(() {
                      isBold = !isBold;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ToggleButton(
                  label: 'I',
                  isActive: isItalic,
                  onTap: () {
                    setState(() {
                      isItalic = !isItalic;
                    });
                  },
                ),
              ],
            ),
          ),

          Spacer(),

          // APPLY BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFF0057B8)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: onApplyPressed,
              child: const Center(child: Text('APPLY CHANGES', style: TextStyle(color: Color(0xFF0057B8), fontWeight: FontWeight.bold))),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const ToggleButton({Key? key, required this.label, required this.isActive, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: isActive ? Colors.blue : Colors.grey[300], borderRadius: BorderRadius.circular(4)),
        child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.black)),
      ),
    );
  }
}

// Custom slider track shape (keep as is)

class HueGradientTrackShape extends SliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Rect trackRect = Rect.fromLTWH(
      offset.dx,
      thumbCenter.dy - (sliderTheme.trackHeight ?? 4) / 2,
      parentBox.size.width,
      sliderTheme.trackHeight ?? 4,
    );

    final Gradient gradient = LinearGradient(
      colors: [Colors.red, Colors.yellow, Colors.green, Colors.cyan, Colors.blue, Colors.deepPurpleAccent, Colors.red],
    );

    final Paint paint = Paint()..shader = gradient.createShader(trackRect);

    context.canvas.drawRRect(RRect.fromRectAndRadius(trackRect, Radius.circular(20)), paint);
  }

  @override
  Rect getPreferredRect({
    bool isDiscrete = false,
    bool isEnabled = false,
    Offset offset = Offset.zero,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
