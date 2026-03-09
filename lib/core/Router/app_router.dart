import "export_routes.dart";
import "package:liness/feature/home/logic/cubit/home_cubit.dart";
import "package:liness/feature/session_features/video_feature/data/repo/video_session_repo.dart";

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    final argument = settings.arguments;

    switch (settings.name) {
      case Routes.onBardingScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => OnBoardingCubit()..init(context),
                  child: const OnBoardingScreen(),
                ));
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.infoScreen:
        return MaterialPageRoute(builder: (_) => const InfoScreen());
      // case Routes.homeScreen:
      //   return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => LoginCubit(),
                  child: const LoginScreen(),
                ));
      case Routes.registerScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => RegisterCubit()..loadSelectedYear(),
                  child: const RegisterScreen(),
                ));
      case Routes.bottomNavigationBarScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => BottomNavigationBarCubit(),
                  child: const ButtomNavigationBar(),
                ));
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit()
              ..loadImages()
              ..getPackagesData()
              ..loadTeachers()
              ..loadSessionResent(),
            child: const HomeScreen(),
          ),
        );
      case Routes.subJectScreen:
        return MaterialPageRoute(builder: (_) => const SubjectScreen());
      case Routes.welcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProfileCubit()
              ..loadCachedImage()
              ..getProfileData(context: context),
            child: const ProfileScreen(),
          ),
        );

      case Routes.coursesScreen:
        argument as List<int?>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CoursesCubit()
              ..getAllCoursesData(
                context: context,
                teacherId: argument[0],
                subjectId: argument[1],
              ),
            child: const CoursesScreen(),
          ),
        );

      case Routes.sessionsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SessionsCubit()
              ..getAllSessionsData(
                context: context,
                //// SET COURSE ID FROM ARGUMENT
                courseId: argument as int,
              ),
            child: const SessionsScreen(),
          ),
        );
      case Routes.teachersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => TeacherCubit()
              ..getAllTeachersdData(
                context: context,
              ),
            child: const TeachersScreen(),
          ),
        );
      case Routes.sessionScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SessionCubit()
              ..getSessionData(
                context: context,
                //// SET SESSION ID FROM ARGUMENT
                sessionId: argument as int,
              ),
            child: const SessionScreen(),
          ),
        );
      case Routes.examScreen:
        argument as List<int?>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ExamCubit()
              ..getExamData(
                context: context,
                //// SET SESSION OR EXAM ID FROM ARGUMENT
                sessionId: argument[0],
                gradeId: argument[1],
              ), //argument as ExamModel
            child: const ExamScreen(),
          ),
        );
      case Routes.videoScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => VideoCubit(
                videoSessionRepository: getIt<VideoSessionRepository>())
              ..getVideoSessionData(
                context: context,
                sessionId: argument as int,
              ),
            child: const VideoScreen(),
          ),
        );
      case Routes.languageScreen:
        return MaterialPageRoute(
          builder: (_) => const LanguageScreen(),
        );
      case Routes.profileSessionsScreen:
        return MaterialPageRoute(
          builder: (_) => ProfileSessionsScreen(
            sessionsInfoList: argument as List<ProfileRecordModel>,
          ),
        );
      case Routes.profileGradesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProfileGradesCubit()
              ..getProfileGradesData(
                context: context,
              ),
            child: const ProfileGradesScreen(),
          ),
        );
      case Routes.packagesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PackagesCubit()
              ..getPackagesData(
                context: context,
              ),
            child: const PackagesScreen(),
          ),
        );
      case Routes.packageDataScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PackageDataCubit()
              ..getPackageDataData(
                context: context,
                packageId: argument as int,
              ),
            child: const PackageDataScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text("No route defined for ${settings.name}"),
                  ),
                ));
    }
  }

  static Widget getScreenByName(
      {required String screenName, Object? arguments}) {
    switch (screenName) {
      case Routes.coursesScreen:
        return BlocProvider(
          create: (context) => CoursesCubit()
            ..getAllCoursesData(
              context: context,
            ),
          child: const CoursesScreen(),
        );
      case Routes.teachersScreen:
        return BlocProvider(
          create: (context) => TeacherCubit()
            ..getAllTeachersdData(
              context: context,
            ),
          child: const TeachersScreen(),
        );
      case Routes.packagesScreen:
        return BlocProvider(
          create: (context) => PackagesCubit()
            ..getPackagesData(
              context: context,
            ),
          child: const PackagesScreen(),
        );
      default:
        return Scaffold(
          body: Center(
            child: Text("No route defined for $screenName"),
          ),
        );
    }
  }
}
