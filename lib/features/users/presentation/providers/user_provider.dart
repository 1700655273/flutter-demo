import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../data/datasources/user_remote_datasource.dart';

/// 自定义异步状态 - 避免与 Riverpod 内置类型冲突
abstract class UiState<T> {
  const UiState();
}

class UiInitial<T> extends UiState<T> {
  const UiInitial();
}

class UiLoading<T> extends UiState<T> {
  const UiLoading();
}

class UiSuccess<T> extends UiState<T> {
  final T data;
  const UiSuccess(this.data);
}

class UiError<T> extends UiState<T> {
  final String message;
  const UiError(this.message);
}

/// 用户仓库抽象
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(int id);
}

/// 用户仓库实现
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<User>> getUsers() async {
    final models = await _remoteDataSource.getUsers();
    return models.toList();
  }

  @override
  Future<User> getUserById(int id) async {
    return await _remoteDataSource.getUserById(id);
  }
}

/// 用户仓库 Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.read(userRemoteDataSourceProvider));
});

/// 用户列表状态管理 - Riverpod StateNotifier
class UserListNotifier extends StateNotifier<UiState<List<User>>> {
  final UserRepository _repository;

  UserListNotifier(this._repository) : super(const UiInitial());

  /// 获取用户列表
  Future<void> fetchUsers() async {
    state = const UiLoading();
    try {
      final users = await _repository.getUsers();
      state = UiSuccess(users);
    } catch (e) {
      state = UiError(e.toString());
    }
  }

  /// 刷新
  Future<void> refresh() async {
    await fetchUsers();
  }
}

/// 用户列表 Provider
final userListProvider =
    StateNotifierProvider<UserListNotifier, UiState<List<User>>>((ref) {
  return UserListNotifier(ref.read(userRepositoryProvider));
});
