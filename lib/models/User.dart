class Userapp {
  String? id;
  String? username;
  String? email;
  String? firstname;
  String? lastname;
  String? birthdate;
  String? phone;
  String? gender;
  String? password;
  String? bio;
  String? avatar;

  Userapp({
    this.id,
    this.username,
    this.email,
    this.firstname,
    this.lastname,
    this.password,
    this.phone,
    this.birthdate,
    this.gender,
    this.bio,
    this.avatar,
  });

  // Khởi tạo từ JSON
  Userapp.fromJson(Map<String, dynamic> json) {
    id = json['id']; // Gán id từ JSON
    email = json['email'];
    username = json['username'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    password = json['password'];
    phone = json['phone'];
    birthdate = json['birthdate'];
    gender = json['gender'];
    bio = json['bio'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id; // Thêm id vào JSON
    data['email'] = email;
    data['username'] = username;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['password'] = password;
    data['phone'] = phone;
    data['birthdate'] = birthdate;
    data['gender'] = gender;
    data['bio'] = bio;
    data['avatar'] = avatar;
    return data;
  }
}
