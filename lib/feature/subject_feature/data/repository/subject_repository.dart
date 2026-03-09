import 'package:dartz/dartz.dart';
import 'package:liness/core/utils/error/exception.dart';
import 'package:liness/core/utils/error/model/error_model.dart';
import 'package:liness/core/utils/networking/api_constant.dart';
import 'package:liness/core/utils/networking/dio_consumer.dart';
import 'package:liness/feature/subject_feature/data/model/subject_model.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class SubjectRepository {
  DioConsumer dioConsumer;
  SubjectRepository({
    required this.dioConsumer,
  });
  Future<Either<ErrorModel, List<SubjectModel>>> fetchSubjects() async {
    try {
      final response = await dioConsumer.get(
        EndPoints.subjectAll,
      );
      final subjects = (response as List)
          .map((json) => SubjectModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(subjects);
    } on ServerExeption catch (e) {
      return Left(e.errorModel);
    }
  }
}
