/// 用户实体 - Domain Layer
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final Company company;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.company,
  });
}

class Company {
  final String name;
  final String catchPhrase;

  const Company({
    required this.name,
    required this.catchPhrase,
  });
}
