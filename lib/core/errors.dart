class AppError implements Exception {
  final String message;
  AppError(this.message);

  @override
  String toString() => message;
}

class AuthError extends AppError {
  AuthError(super.message);
}

class NetworkError extends AppError {
  NetworkError(super.message);
}

class DatabaseError extends AppError {
  DatabaseError(super.message);
}
