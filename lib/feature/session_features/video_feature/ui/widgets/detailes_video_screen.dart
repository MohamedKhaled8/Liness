import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/Router/export_routes.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class DetailesVideoScreen extends StatefulWidget {
  const DetailesVideoScreen({
    super.key,
  });

  @override
  State<DetailesVideoScreen> createState() => _DetailesVideoScreenState();
}

class _DetailesVideoScreenState extends State<DetailesVideoScreen> {
  late Timer _timer;
  final List<String> _adhkar = [
    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
    "اللَّهُ أَكْبَرُ",
    "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
    "لَا إِلٰهَ إِلَّا اللَّهُ",
    "اللهم اجعلنا من أهل القرآن الذين هم أهلك وخاصتك.",
    "اللهم لا سهل إلا ما جعلته سهلاً، وأنت تجعل الحزن إذا شئت سهلاً.",
    "اللهم اجعلنا من الذين يستمعون القول فيتبعون أحسنه.",
    "اللهم ارزقنا العلم النافع والعمل الصالح.",
    "اللهم آمين يا أرحم الراحمين.",
    "اللهم افتح لي أبواب رزقك بغير حساب.",
    "توكلت على الله، ولا حول ولا قوة إلا بالله.",
    "اللهم اجعلني من الشاكرين، الحمد لله على كل حال.",

    // Dua for success and studying:
    "اللهم إني أسالك علمًا نافعًا ورزقًا طيبًا وعملاً متقبلًا.",
    "رَبِّ يَسِّرْ وَلا تُعَسِّرْ وَتَمِّمْ بِالْخَيْرِ.",
    "اللهم إني أسالك من فضلك ورحمتك، فإنه لا يملكها إلا أنت.",
    "اللهم اشرح لي صدري ويسر لي أمري.",
    "اللهم اجعلني من الذين يوفقون في حياتهم ودراستهم.",

    // Dua for success:
    "اللهم افتح لي أبواب التوفيق في كل ما أعمل.",
    "اللهم ارزقني التوفيق والسداد في كل أمر.",
    "اللهم اجعل النجاح رفيقي في دراستي وفي حياتي.",

    // General advice:
    "من يزرع الحقول يعش في الظلال.",
    "لا تهدر وقتك في الشكوى، فالوقت ثمين جدًا.",
    "من طلب العلا سهر الليالي.",
    "العقل زينة، والنفس طيبة، والعمل عبادة.",
    "الصبر مفتاح الفرج.",
    "العقل هو السلاح، والإرادة هي الطريق.",

    // Dua for guidance and ease:
    "اللهم اجعل لي من كل همٍ فرجًا، ومن كل ضيقٍ مخرجًا.",
    "اللهم ارزقني الفهم الصحيح والصبر على ما أواجه.",
    "اللهم اجعلني من الذين يستمعون القول فيتبعون أحسنه.",
    "اللهم إني أستغفرك من كل ذنب، وأتوب إليك.",
    "اللهم اجعلني من المتوكلين عليك، ولا تجعلني من القانطين.",

    // Dua for success in studies:
    "اللهم إني أسالك برحمتك أن تجعل دراستي سهلة وميسرة.",
    "اللهم اجعلني من المتفوقين في دراستي، وارزقني العلم النافع.",
    "اللهم اجعلني من أهل التفوق والنجاح في الدنيا والآخرة.",

    // Motivational supplications:
    "اللهم اجعل لي من كل شدة مخرجًا، ومن كل ضيق فرجًا.",
    "اللهم ارفعني في الدنيا والآخرة.",
    "اللهم اجعل النجاح حليفي في كل مسعى، والتوفيق رفيقي في كل خطوة.",
    "اللهم إني أسالك رزقًا مباركًا وعملاً متقبلاً."
  ];

  int _currentAdhkarIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCache();
    _loadCurrentIndex();
    // تحديث الأذكار كل 30 ثانية
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _currentAdhkarIndex = (_currentAdhkarIndex + 1) % _adhkar.length;
        _saveCurrentIndex();
      });
    });
  }

  Future<void> _initializeCache() async {
    await getIt<CacheHelper>().init(); // تهيئة SharedPreferences
  }

  Future<void> _loadCurrentIndex() async {
    final index = getIt<CacheHelper>().getData(key: 'currentAdhkarIndex') ?? 0;
    setState(() {
      _currentAdhkarIndex = index as int;
    });
  }

  Future<void> _saveCurrentIndex() async {
    await getIt<CacheHelper>()
        .saveData(key: 'currentAdhkarIndex', value: _currentAdhkarIndex);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
        decoration: BoxDecoration(
          color: ChangeTranslateAndTheme.isDarkMode(context)
              ? ColorsManger.mainBlue.withOpacity(0.2)
              : ColorsManger.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.sp),
            topRight: Radius.circular(20.sp),
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            verticalSpace(.5),
            if (!isLandscape) // Only show these images in portrait mode
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          "https://youtu.be/8LQKHx8PLwI?si=J7qnIcMN54tnenPX");
                    },
                    child: AppImageHelper(
                      path: "assets/images/png/youtube.png",
                      width: 10.w,
                      height: 10.h,
                    ),
                  ),
                  horizintalSpace(7),
                  GestureDetector(
                    onTap: () {
                      _launchURL("https://www.facebook.com/elkemaacademy");
                    },
                    child: AppImageHelper(
                      color: ColorsManger.white,
                      path: "assets/images/png/facebook.png",
                      width: 10.w,
                      height: 10.h,
                    ),
                  ),
                ],
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Text(
                _adhkar[_currentAdhkarIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: stv(
                    context: context,
                    mobile: MediaQuery.of(context).size.width * 0.05,
                    tablet: MediaQuery.of(context).size.width * 0.05,
                    desktop: MediaQuery.of(context).size.width * 0.02,
                  ),
                  color: ColorsManger.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0.sp),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Developer By ",
                            style: TextStyle(
                              fontSize: stv(
                                context: context,
                                mobile:
                                    MediaQuery.of(context).size.width * 0.04,
                                tablet:
                                    MediaQuery.of(context).size.width * 0.04,
                                desktop:
                                    MediaQuery.of(context).size.width * 0.02,
                              ),
                              color: ColorsManger.red,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextSpan(
                            text: "Eng.Mohamed Khaled & Eng.Mohamed Elsafty ",
                            style: TextStyle(
                              fontSize: stv(
                                context: context,
                                mobile:
                                    MediaQuery.of(context).size.width * 0.04,
                                tablet:
                                    MediaQuery.of(context).size.width * 0.04,
                                desktop:
                                    MediaQuery.of(context).size.width * 0.02,
                              ),
                              color: ColorsManger.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          TextSpan(
                            text: "All Copyright Mr.Mohamed Mustafa© 2024",
                            style: TextStyle(
                              fontSize: stv(
                                context: context,
                                mobile:
                                    MediaQuery.of(context).size.width * 0.04,
                                tablet:
                                    MediaQuery.of(context).size.width * 0.04,
                                desktop:
                                    MediaQuery.of(context).size.width * 0.02,
                              ),
                              color: ColorsManger.red,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
