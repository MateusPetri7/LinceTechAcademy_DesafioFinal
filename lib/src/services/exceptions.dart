/// Exception thrown when a resource is not found.
class NotFoundException implements Exception {
  /// The error message associated with the exception.
  final String message;

  /// Creates a [NotFoundException] with the given [message].
  NotFoundException(this.message);
}

/// Exception thrown when an internal server error occurs.
class InternalServerErrorException implements Exception {
  /// The error message associated with the exception.
  final String message;

  /// Creates an [InternalServerErrorException] with the given [message].
  InternalServerErrorException(this.message);
}