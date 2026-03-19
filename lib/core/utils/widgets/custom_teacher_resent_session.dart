import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class TeacherResentSessionWidgets extends StatefulWidget {
  final double widthImage;
  final double heightImage;
  final String image;
  final String imageTeacher;
  final String nameCource;
  final int index;
  final List<Color> colorsList;

  const TeacherResentSessionWidgets({
    Key? key,
    required this.widthImage,
    required this.heightImage,
    required this.image,
    required this.imageTeacher,
    required this.nameCource,
    required this.index,
    required this.colorsList,
  }) : super(key: key);

  @override
  State<TeacherResentSessionWidgets> createState() =>
      _TeacherResentSessionWidgetsState();
}

class _TeacherResentSessionWidgetsState
    extends State<TeacherResentSessionWidgets>
    with SingleTickerProviderStateMixin {
  late AnimationController _beamController;

  @override
  void initState() {
    super.initState();
    _beamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _beamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    final accentColors = widget.colorsList.isEmpty
        ? [
            const Color(0xFF6366F1),
            const Color(0xFF8B5CF6),
            const Color(0xFF06B6D4),
            const Color(0xFFF59E0B),
            const Color(0xFFEC4899),
            const Color(0xFF10B981),
            const Color(0xFFF97316),
          ]
        : widget.colorsList;

    Color accent = accentColors[widget.index % accentColors.length];

    double imgSize = stv(
      context: context,
      mobile: otv(context: context, portrait: 30.sp, landscape: 30.sp),
      tablet: otv(context: context, portrait: 34.sp, landscape: 28.sp),
      desktop: 30.sp,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: AnimatedBuilder(
        animation: _beamController,
        builder: (context, child) {
          return CustomPaint(
            foregroundPainter: _BorderBeamPainter(
              progress: _beamController.value,
              color: accent,
              borderRadius: 16.sp,
            ),
            child: child,
          );
        },
        child: Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E2C) : Colors.white,
            borderRadius: BorderRadius.circular(16.sp),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(isDarkMode ? 0.06 : 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: accent.withOpacity(isDarkMode ? 0.15 : 0.12),
              width: 0.8,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Teacher Image with Ring ---
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [accent, accent.withOpacity(0.3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  width: imgSize,
                  height: imgSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: AppImageHelper(
                      path: widget.image,
                      fit: BoxFit.cover,
                      width: imgSize,
                      height: imgSize,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 14.sp),

              // --- Info Section ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.nameCource,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF111827),
                        height: 1.2,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2.sp),
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 14.sp,
                            color: accent,
                          ),
                        ),
                        SizedBox(width: 4.sp),
                        Expanded(
                          child: Text(
                            widget.imageTeacher,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? Colors.white70
                                  : Colors.grey[600],
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.sp),

              // --- Play Icon Action ---
              Container(
                padding: EdgeInsets.all(6.sp),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: accent,
                  size: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BorderBeamPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double borderRadius;

  _BorderBeamPainter({
    required this.progress,
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final path = Path()..addRRect(rRect);

    final metrics = path.computeMetrics().first;
    final totalLength = metrics.length;

    // Beam 1: Forward (Starts at Top-Left)
    const beamLengthFactor = 0.18;
    final start1 = totalLength * progress;
    final end1 = start1 + (totalLength * beamLengthFactor);

    Path beamPath1;
    if (end1 > totalLength) {
      beamPath1 = metrics.extractPath(start1, totalLength);
      beamPath1.addPath(metrics.extractPath(0, end1 - totalLength), Offset.zero);
    } else {
      beamPath1 = metrics.extractPath(start1, end1);
    }

    // Beam 2: Forward but offset by 0.5 (starts from opposite corners)
    final progress2 = (progress + 0.5) % 1.0;
    final start2 = totalLength * progress2;
    final end2 = start2 + (totalLength * beamLengthFactor);

    Path beamPath2;
    if (end2 > totalLength) {
      beamPath2 = metrics.extractPath(start2, totalLength);
      beamPath2.addPath(metrics.extractPath(0, end2 - totalLength), Offset.zero);
    } else {
      beamPath2 = metrics.extractPath(start2, end2);
    }

    final glowPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final mainPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    // Draw both paths
    canvas.drawPath(beamPath1, glowPaint);
    canvas.drawPath(beamPath1, mainPaint);
    canvas.drawPath(beamPath2, glowPaint);
    canvas.drawPath(beamPath2, mainPaint);
  }

  @override
  bool shouldRepaint(_BorderBeamPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
