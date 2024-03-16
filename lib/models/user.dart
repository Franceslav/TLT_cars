class User {
  Role role;
  bool isAuth;

  User({
    required this.role,
    required this.isAuth,
  });
}

enum Role {
  driver,
  pass,
  undefined,
}
