import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

/// 用户远程数据源 - Data Layer
class UserRemoteDataSource {
  final DioClient _dioClient;

  UserRemoteDataSource(this._dioClient);

  Future<List<UserModel>> getUsers() async {
    final response = await _dioClient.get<List<dynamic>>('/users');
    final data = response.data as List<dynamic>;
    return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<UserModel> getUserById(int id) async {
    final response = await _dioClient.get<Map<String, dynamic>>('/users/$id');
    return UserModel.fromJson(response.data!);
  }
}

/// 用户远程数据源 Provider
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSource(ref.read(dioClientProvider));
});
