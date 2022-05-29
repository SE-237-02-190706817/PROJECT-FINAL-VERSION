class FbUser {
  String uid;
  FbUser({
    required this.uid,
  });
}

class UserData {
  String name, phone, email;
  double wallet;
  UserData(
      {required this.email,
      required this.name,
      required this.phone,
      required this.wallet});
}
