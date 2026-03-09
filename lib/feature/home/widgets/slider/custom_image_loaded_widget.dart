import 'package:carousel_slider/carousel_slider.dart';
import 'package:liness/core/Router/export_routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liness/feature/home/data/model/image_model.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class CustomImageLoadedWidget extends StatelessWidget {
  const CustomImageLoadedWidget({
    super.key,
    required this.images,
  });

  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    var idDarkMode = ChangeTranslateAndTheme.isDarkMode(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.sp),
      child: Stack(
        children: [
          CarouselSlider(
            items: images
                .map(
                  (image) => CachedNetworkImage(
                    imageUrl: image.imageUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                context.read<HomeCubit>().changePage(index);
              },
            ),
            carouselController: context.read<HomeCubit>().carouselController,
          ),
          Positioned(
            bottom: 2.w,
            left: 0,
            right: 0,
            child: Center(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return AnimatedSmoothIndicator(
                    activeIndex: context.read<HomeCubit>().currentIndex,
                    count: images.length,
                    effect: WormEffect(
                      dotColor: ColorsManger.white,
                      dotHeight: .5.h,
                      dotWidth: 10.w,
                      activeDotColor: idDarkMode
                          ? ColorsManger.red
                          : ColorsManger.primaryColor,
                    ),
                    onDotClicked: (index) {
                      context
                          .read<HomeCubit>()
                          .carouselController
                          .animateToPage(index);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
