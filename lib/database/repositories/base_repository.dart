/// Base repository interface for common database operations
abstract class BaseRepository<T, IdType> {
  Future<T> create(T entity);
  Future<T> read(IdType id);
  Future<List<T>> readAll();
  Future<T> update(T entity);
  Future<void> delete(IdType id);
}

/// Generic repository implementation that can be extended by specific repositories
abstract class BaseRepositoryImpl<T, IdType>
    implements BaseRepository<T, IdType> {
  // Common functionality can be implemented here
}
