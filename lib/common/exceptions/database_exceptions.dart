/// Database-related exceptions
library;

/// Exception thrown when database connection fails
class DatabaseConnectionException implements Exception {
  const DatabaseConnectionException([this.message = 'Database connection failed']);
  
  final String message;
  
  @override
  String toString() => 'DatabaseConnectionException: $message';
}

/// Exception thrown when WASM database is not properly initialized
class WasmDatabaseException implements Exception {
  const WasmDatabaseException([
    this.message = 'WASM database not properly initialized',
  ]);
  
  final String message;
  
  @override
  String toString() => 'WasmDatabaseException: $message';
}

/// Exception thrown when a database query fails
class DatabaseQueryException implements Exception {
  const DatabaseQueryException([this.message = 'Database query failed']);
  
  final String message;
  
  @override
  String toString() => 'DatabaseQueryException: $message';
}
