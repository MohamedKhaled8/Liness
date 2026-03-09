import 'dart:ui';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/function/get_youtube_video_id.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';
import 'package:liness/feature/session_features/video_feature/data/model/video_model.dart';
import 'package:liness/feature/session_features/video_feature/logic/cubit/video_cubit.dart';
import 'package:liness/feature/session_features/video_feature/logic/state/video_state.dart';
import 'package:liness/feature/session_features/video_feature/ui/views/vimeo_player_view.dart';
import 'package:liness/feature/session_features/video_feature/ui/views/youtube_video_player_view.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final GlobalKey _playerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<void> _safeLaunchURL(String rawUrl) async {
    if (rawUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ChangeTranslateAndTheme.isArabic
              ? "لا يوجد رابط متاح"
              : "No link available"),
        ));
      }
      return;
    }

    Uri? url = Uri.tryParse(rawUrl);
    // If it's a relative path, prepend baseUrl
    if (url == null || !url.hasScheme) {
      String cleanRaw = rawUrl.startsWith('/') ? rawUrl.substring(1) : rawUrl;
      url = Uri.tryParse("${EndPoints.baseUrl}$cleanRaw");
    }

    if (url != null) {
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          // One final try with WhatsApp special case if it's a number check
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(ChangeTranslateAndTheme.isArabic
                  ? "لا يمكن فتح الرابط"
                  : "Cannot open link"),
            ));
          }
        }
      } catch (e) {
        debugPrint("Error launching URL: $e");
      }
    }
  }

  void _showAddNoteDialog() {
    final TextEditingController noteController = TextEditingController();
    final cubit =
        context.read<VideoCubit>(); // Capture cubit from current context

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit, // Pass the already existing cubit to the dialog
        child: Builder(builder: (context) {
          // Use a builder to get a context under the BlocProvider
          return AlertDialog(
            backgroundColor: ChangeTranslateAndTheme.isDarkMode(context)
                ? ColorsManger.mainColor
                : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.sp)),
            title: Text(
              ChangeTranslateAndTheme.isArabic ? "إضافة ملاحظة" : "Add Note",
              style: StylesManager.textStyle18Bold(context),
            ),
            content: TextField(
              controller: noteController,
              maxLines: 4,
              style: TextStyle(
                  color: ChangeTranslateAndTheme.isDarkMode(context)
                      ? Colors.white
                      : Colors.black),
              decoration: InputDecoration(
                hintText: ChangeTranslateAndTheme.isArabic
                    ? "اكتب ملاحظتك هنا..."
                    : "Write your note here...",
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.sp)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                    ChangeTranslateAndTheme.isArabic ? "إلغاء" : "Cancel",
                    style: const TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManger.mainBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp)),
                ),
                onPressed: () {
                  if (noteController.text.trim().isNotEmpty) {
                    cubit.addNote(cubit.currentSessionId ?? 0,
                        noteController.text.trim());
                    Navigator.pop(context);
                  }
                },
                child: Text(ChangeTranslateAndTheme.isArabic ? "حفظ" : "Save",
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoCubit = context.read<VideoCubit>();
    final orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;

    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: BlocBuilder<VideoCubit, VideoState>(
        builder: (context, state) {
          if (videoCubit.videoModel == null) {
            return const Scaffold(
              backgroundColor: ColorsManger.mainColor,
              body: Center(child: LoadingIndicator()),
            );
          }

          final videoModel = videoCubit.videoModel!;

          return PopScope(
            canPop: true,
            onPopInvoked: (didPop) async {
              if (didPop) {
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                ]);
              }
            },
            child: Scaffold(
              backgroundColor: isLandscape
                  ? Colors.black
                  : (ChangeTranslateAndTheme.isDarkMode(context)
                      ? ColorsManger.mainColor
                      : const Color(0xFFF8FAFC)),
              body: SafeArea(
                top: !isLandscape,
                bottom: false,
                left: false,
                right: false,
                child: Stack(
                  children: [
                    if (!isLandscape)
                      Positioned.fill(
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(color: Colors.black),
                              ),
                            ),
                            SliverToBoxAdapter(
                                child: _buildVideoInfo(context, videoModel)),
                            SliverToBoxAdapter(
                                child:
                                    _buildActionButtons(context, videoModel)),
                            if (videoCubit.currentVideoNotes.isNotEmpty)
                              SliverToBoxAdapter(
                                  child: _buildUserNotesSection(
                                      context, videoCubit.currentVideoNotes)),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    20.sp, 20.sp, 20.sp, 5.sp),
                                child: Text(
                                  ChangeTranslateAndTheme.isArabic
                                      ? "الوصف"
                                      : "Description",
                                  style: StylesManager.textStyle18Bold(context)
                                      .copyWith(fontSize: 16.sp),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                                child: _buildDescription(context, videoModel)),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    20.sp, 20.sp, 20.sp, 10.sp),
                                child: Text(
                                  ChangeTranslateAndTheme.isArabic
                                      ? "كورسات المنصة"
                                      : "Platform Courses",
                                  style: StylesManager.textStyle18Bold(context)
                                      .copyWith(fontSize: 16.sp),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => _buildSuggestionItem(
                                    context, videoModel, index),
                                childCount: 4,
                              ),
                            ),
                            SliverToBoxAdapter(child: verticalSpace(6)),
                          ],
                        ),
                      ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: isLandscape
                          ? MediaQuery.of(context).size.height
                          : (MediaQuery.of(context).size.width / (16 / 9)),
                      child: _buildFixedVideoPlayer(videoCubit),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _buildBackButton(context, isLandscape),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFixedVideoPlayer(VideoCubit videoCubit) {
    return Container(
      key: _playerKey,
      color: Colors.black,
      child: _buildVideoPlayer(videoCubit),
    );
  }

  Widget _buildUserNotesSection(BuildContext context, List<String> notes) {
    bool isDark = ChangeTranslateAndTheme.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: ColorsManger.mainBlue, size: 20.sp),
              horizintalSpace(2),
              Text(
                ChangeTranslateAndTheme.isArabic ? "ملاحظاتك" : "My Notes",
                style: StylesManager.textStyle18Bold(context)
                    .copyWith(fontSize: 15.sp),
              ),
            ],
          ),
          verticalSpace(1),
          ...notes.reversed
              .map((note) => Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8.sp),
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12.sp),
                      border: Border.all(
                          color: ColorsManger.mainBlue.withOpacity(0.2)),
                    ),
                    child: Text(
                      note,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildVideoInfo(BuildContext context, VideoModel videoModel) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  videoModel.sessionName,
                  style: StylesManager.textStyle18Bold(context)
                      .copyWith(fontSize: 20.sp, height: 1.3),
                ),
              ),
              Icon(Icons.keyboard_arrow_down,
                  size: 24.sp, color: ColorsManger.gray),
            ],
          ),
          verticalSpace(1.5),
          Row(
            children: [
              _buildInfoChip(context, Icons.visibility_outlined, "1.2K views"),
              horizintalSpace(4),
              _buildInfoChip(
                  context, Icons.calendar_today_outlined, "2 days ago"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: ColorsManger.gray),
        horizintalSpace(1),
        Text(
          label,
          style: TextStyle(
              color: ColorsManger.gray,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, VideoModel videoModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _buildActionItem(
              context,
              Icons.note_add_outlined,
              ChangeTranslateAndTheme.isArabic ? "كتابة ملاحظة" : "Write Note",
              _showAddNoteDialog,
            ),
            if (videoModel.fileLink.isNotEmpty)
              _buildActionItem(
                context,
                Icons.file_download_outlined,
                ChangeTranslateAndTheme.isArabic
                    ? "تحميل الملف"
                    : "Download File",
                () => _safeLaunchURL(videoModel.fileLink),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    bool isDark = ChangeTranslateAndTheme.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.sp),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20.sp),
            border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 18.sp, color: isDark ? Colors.white : Colors.black87),
              horizintalSpace(2),
              Text(
                label,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context, VideoModel videoModel) {
    bool isDark = ChangeTranslateAndTheme.isDarkMode(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.sp),
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15.sp),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ChangeTranslateAndTheme.isArabic
                ? "في هذه الحصة سنشرح بالتفصيل الدرس الأول مع حل مجموعة متنوعة من الأسئلة الصعبة."
                : "In this session, we will explain the first lesson in detail with a variety of challenging questions.",
            style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.white70 : Colors.black54,
                height: 1.5),
          ),
          if (videoModel.fileTitle.isNotEmpty) verticalSpace(1),
          if (videoModel.fileTitle.isNotEmpty)
            InkWell(
              onTap: () => _safeLaunchURL(videoModel.fileLink),
              child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: 8.sp, horizontal: 12.sp),
                decoration: BoxDecoration(
                    color: ColorsManger.mainBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.sp)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.picture_as_pdf,
                        color: ColorsManger.red, size: 16.sp),
                    horizintalSpace(2),
                    Text(videoModel.fileTitle,
                        style: TextStyle(
                            color: ColorsManger.mainBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(
      BuildContext context, VideoModel videoModel, int index) {
    final List<String> courseNames = [
      "كورس المراجعة النهائية - التفاضل",
      "كورس الأساسيات لطلاب الثانوية",
      "حل نماذج الامتحانات الاسترشادية",
      "كورس الديناميكا - القسم العلمي"
    ];
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 8.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.sp),
                  child: AppImageHelper(
                      path: videoModel.sessionImgae,
                      width: 35.w,
                      height: 10.h,
                      fit: BoxFit.cover),
                ),
                Positioned.fill(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.sp))))
              ],
            ),
            horizintalSpace(4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ChangeTranslateAndTheme.isArabic
                        ? courseNames[index % 4]
                        : "Platform Course Title",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: StylesManager.textStyle18Bold(context)
                        .copyWith(fontSize: 14.sp, height: 1.2),
                  ),
                  verticalSpace(0.5),
                  Text("Liness Platform",
                      style:
                          TextStyle(color: ColorsManger.gray, fontSize: 12.sp)),
                  verticalSpace(0.5),
                  Text("Promoted Course",
                      style: TextStyle(
                          color: ColorsManger.mainBlue.withOpacity(0.7),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, bool isLandscape) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(2.sp),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24)),
          child: IconButton(
            onPressed: () async {
              if (MediaQuery.of(context).orientation == Orientation.landscape) {
                await SystemChrome.setPreferredOrientations(
                    [DeviceOrientation.portraitUp]);
                await Future.delayed(const Duration(milliseconds: 300));
              }
              if (context.mounted) Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, size: 20.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(VideoCubit videoCubit) {
    if (videoCubit.videoModel == null)
      return const Center(child: LoadingIndicator());

    final videoLink = videoCubit.videoModel!.videoLink;

    // Improved detection: if it's already an ID (not starting with http), it's likely Vimeo
    final isVimeo = !videoLink.startsWith("http") &&
        !videoLink.contains("youtube") &&
        !videoLink.contains("youtu.be");

    if (isVimeo) {
      return VimeoPlayerView(autoPlay: true, vimeoId: videoLink);
    } else {
      final videoId = getYouTubeVideoId(videoLink);
      if (videoId == null || videoId.isEmpty) {
        // One last fallback: if it's already an 11-char ID but getYouTube didn't catch it
        if (videoLink.length == 11 && !videoLink.contains("/")) {
          return YoutubePlayerView(
              autoPlay: true, mute: false, videoId: videoLink);
        }
        return const Center(
            child: Icon(Icons.error_outline, color: Colors.red, size: 48));
      }
      return YoutubePlayerView(autoPlay: true, mute: false, videoId: videoId);
    }
  }
}
