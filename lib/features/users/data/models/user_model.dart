import '../../domain/entities/user.dart';

/// 用户数据模型 - Data Layer
/// 负责 JSON 与 Domain Entity 之间的转换
class UserModel extends User {
  const UserModel({
    required int id,
    required String name,
    required String username,
    required String email,
    required String phone,
    required String website,
    required Company company,
  }) : super(
          id: id,
          name: name,
          username: username,
          email: email,
          phone: phone,
          website: website,
          company: company,
        );

  /// 从 JSON 创建
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      website: json['website'] as String? ?? '',
      company: Company(
        name: json['company']?['name'] as String? ?? '',
        catchPhrase: json['company']?['catchPhrase'] as String? ?? '',
      ),
    );
  }

  /// 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
      'company': {
        'name': company.name,
        'catchPhrase': company.catchPhrase,
      },
    };
  }
}
