import 'package:liness/core/Router/export_routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/feature/home/widgets/slide_in_card.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:liness/feature/home/data/model/session_resent_model.dart';

class LoadedSessionResentWidget extends StatelessWidget {
  const LoadedSessionResentWidget({
    Key? key,
    required this.screenWidth,
    required this.colorsList,
  }) : super(key: key);

  final double screenWidth;
  final List<Color> colorsList;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var recentSessions = context.read<HomeCubit>().recentSessions;

        return ListView.separated(
          cacheExtent: 500,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 14.h),
          itemCount: recentSessions.length,
          separatorBuilder: (context, index) => SizedBox(height: 10.sp),
          itemBuilder: (context, index) {
            SessionResentModel session = recentSessions[index];

            return SlideInCard(
              screenWidth: screenWidth,
              colorsList: colorsList,
              session: session,
              index: index,
            );
          },
        );
      },
    );
  }
}
