import 'package:dartz/dartz.dart';
import '../errors/failures/failures.dart';
import '../errors/exception/exceptions.dart';

typedef DataSourceCall<T> = Future<T> Function();

abstract class BaseRepository {
  Future<Either<GFailure, T>> safeCall<T>(DataSourceCall<T> call) async {
    try {
      final result = await call();
      return Right(result);
    } on GException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(GUnknownFailure(message: e.toString()));
    }
  }

  GFailure _mapExceptionToFailure(GException exception) {
    if (exception is GServerException) {
      // Use GServerFailure.fromStatusCode to ensure proper message extraction
      return GServerFailure.fromStatusCode(
        statusCode: exception.statusCode,
        message: exception.message,
        originalError: exception.originalError,
      );
    } else if (exception is GNetworkException) {
      return GNetworkFailure(
        code: exception.code,
        message: exception.message,
        originalError: exception.originalError,
      );
    } else if (exception is GCacheException) {
      return CacheFailure(
        code: exception.code,
        message: exception.message,
        originalError: exception.originalError,
      );
    } else if (exception is GUnauthorizedException) {
      return GUnknownFailure();
    } else {
      return GUnknownFailure(message: exception.message, code: exception.code);
    }
  }
}

