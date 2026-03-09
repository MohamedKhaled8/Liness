import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/Router/export_routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/on_boarding_screen_feature/data/model/on_barding_model.dart';

class PageViewItems extends StatelessWidget {
  final int index;
  const PageViewItems({
    Key? key,
    required this.index,
    required this.items,
  }) : super(key: key);

  final List<OnBardingItemModel> items;

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);

    return Padding(
      padding: EdgeInsets.only(
          left: 8.w,
          right: 8.w,
          bottom:
              stv(context: context, mobile: 8.h, tablet: 8.h, desktop: 20.h)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImageHelper(
            height: stv(
                context: context, mobile: null, tablet: null, desktop: 55.sp),
            path: items[index].image,
            color: isDarkMode ? ColorsManger.black : ColorsManger.white,
          ),
          verticalSpace(10),
          Text(
            items[index].title,
            style: StylesManager.textStyle22,
          ),
          verticalSpace(2),
          Text(
            items[index].description,
            style: StylesManager.textStyle17(context).copyWith(
              color: isDarkMode ? ColorsManger.white : ColorsManger.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
