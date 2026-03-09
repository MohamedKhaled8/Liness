import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/model/teacher_card_model.dart';

class TeacherRepository {
  //// GET ALL TEACHERS DATA METHOD
  Future<Either<ErrorModel, List<TeacherCardModel>>>
      getAllTeachersdData() async {
    try {
      ////
      final response = await getIt<DioConsumer>().get(
        EndPoints.allTeachers,
      );
      ////
      final teacherDataModelList = TeacherCardModel.fromListJson(response);
      ////
      return Right(teacherDataModelList);
      ////
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
