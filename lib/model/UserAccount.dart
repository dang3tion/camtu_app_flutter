class UserAccount {
  String avatar;
  String userId;
  String name;
  String address;
  String birthday;
  String phoneNo;
  String nameSchool;
  String email;
  String password;
  bool typeUser;

  UserAccount(
      {this.avatar,
      this.userId,
      this.name,
      this.address,
      this.birthday,
      this.phoneNo,
      this.nameSchool,
      this.email,
      this.password,
      this.typeUser});

  UserAccount.value(this.avatar, this.userId, this.name, this.address, this.birthday,
      this.phoneNo, this.nameSchool, this.email, this.password, this.typeUser);

  @override
  String toString() {
    return 'User{avatar: $avatar, userId: $userId, name: $name, address: $address, birthday: $birthday, phoneNo: $phoneNo, nameSchool: $nameSchool, email: $email, password: $password, typeUser: $typeUser}';
  }
}
