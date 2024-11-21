// lib/data/cache/cache_client.dart

class CacheClient {
  final Map<String, dynamic> _cache = {};

  T? read<T>({required String key}) {
    return _cache[key] as T?;
  }

  void write<T>({required String key, required T value}) {
    _cache[key] = value;
  }
}

const String userCacheKey = 'cached_user';
