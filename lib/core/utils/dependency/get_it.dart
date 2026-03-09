import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:liness/core/app_cubit/app_cubit.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/core/utils/networking/api_consumer.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/core/utils/networking/connectivity_network.dart';
import 'package:liness/core/utils/helper/secure_storage_helper%20.dart';
import 'package:liness/feature/home/data/repository/home_repository.dart';
import 'package:liness/feature/teachers_feature/logic/cubit/teacher_cubit.dart';
import 'package:liness/feature/auth/login/data/repository/login_repository.dart';
import 'package:liness/feature/auth/register/data/repository/register_repository.dart';
import 'package:liness/feature/subject_feature/data/repository/subject_repository.dart';
import 'package:liness/feature/teachers_feature/data/repository/teacher_repository.dart';
import 'package:liness/feature/session_features/video_feature/data/repo/video_session_repo.dart';
import 'package:liness/feature/profile_features/main_profile_feature/data/repository/profile_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Register SecureStorageHelper
  getIt.registerLazySingleton<SecureStorageHelper>(() => SecureStorageHelper());
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper());

  getIt.registerLazySingleton<TeacherCubit>(() => TeacherCubit());

  // Register DioConsumer directly
  getIt.registerLazySingleton<DioConsumer>(() => DioConsumer(
        dio: Dio(),
      ));

  // Register ApiConsumer as DioConsumer
  getIt.registerLazySingleton<ApiConsumer>(() => getIt<DioConsumer>());

  // Register other repositories
  getIt.registerLazySingleton<RegisterRepository>(
    () => RegisterRepository(
      dioConsumer: getIt<DioConsumer>(),
    ),
  );
  getIt.registerLazySingleton<VideoSessionRepository>(
      () => VideoSessionRepository());

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepository(),
  );

  getIt.registerLazySingleton<TeacherRepository>(() => TeacherRepository());

  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepository(
      api: getIt<DioConsumer>(),
    ),
  );

  // Register ConnectivityNetwork
  getIt.registerLazySingleton<ConnectivityNetwork>(() => ConnectivityNetwork());

  // Register ProfileRepository after all its dependencies are registered
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(dioConsumer: getIt<DioConsumer>()),
  );

  getIt.registerLazySingleton<SubjectRepository>(() => SubjectRepository(
        dioConsumer: getIt<DioConsumer>(),
      ));
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());
}
