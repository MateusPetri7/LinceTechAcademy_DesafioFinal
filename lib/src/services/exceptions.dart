class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);
}

class InternalServerErrorException implements Exception {
  final String message;

  InternalServerErrorException(this.message);
}