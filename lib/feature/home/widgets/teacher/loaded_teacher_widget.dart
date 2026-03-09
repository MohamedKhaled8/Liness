import 'package:carousel_slider/carousel_slider.dart';
import 'package:liness/core/Router/export_routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/custom_teacher_card_widget.dart';

class LoadedTeacherWidget extends StatelessWidget {
  const LoadedTeacherWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: stv(
        context: context,
        mobile: otv(context: context, portrait: 37.h, landscape: 90.h),
        tablet: otv(context: context, portrait: 37.h, landscape: 65.h),
        desktop: otv(context: context, portrait: 65.h, landscape: 60.h),
      ),
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: context.read<HomeCubit>().teachers.length,
        itemBuilder: (context, index, realIndex) {
          return CustomTeachersCardWidget(
            imageFit: BoxFit.fill,
            widthImage: stv(
              mobile: otv(context: context, portrait: 65.w, landscape: 35.w),
              tablet: otv(context: context, portrait: 55.w, landscape: 35.w),
              desktop: otv(context: context, portrait: 40.w, landscape: 35.w),
              context: context,
            ),
            teacherCardModel: context.read<HomeCubit>().teachers[index],
          );
        },
        options: CarouselOptions(
          height: stv(
            context: context,
            mobile: otv(context: context, portrait: 37.h, landscape: 90.h),
            tablet: otv(context: context, portrait: 37.h, landscape: 75.h),
            desktop: otv(context: context, portrait: 65.h, landscape: 60.h),
          ),
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          enlargeCenterPage: true,
          viewportFraction: stv(
            context: context,
            mobile: otv(context: context, portrait: 0.8, landscape: 0.6),
            tablet: otv(context: context, portrait: 0.7, landscape: 0.5),
            desktop: otv(context: context, portrait: 0.6, landscape: 0.4),
          ),
          aspectRatio: 16 / 9,
          onPageChanged: (index, reason) {},
        ),
      ),
    );
  }
}
