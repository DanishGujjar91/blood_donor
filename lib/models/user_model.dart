class UserModel {
  final String? name;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? phoneNo;
  final String? image;
  final String? id;
  final String? bloodType;
  UserModel({
    this.id,
    this.image,
    this.name,
    this.email,
    this.password,
    this.confirmPassword,
    this.phoneNo,
    this.bloodType,
  });

  UserModel.fromJson(
    Map<String, dynamic> json,
  )   : id = json['id'],
        image = json['image'],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        confirmPassword = json['confirmPassword'],
        phoneNo = json['phoneNo'],
        bloodType = json['bloodType'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'phoneNo': phoneNo,
        'image': image,
        'bloodType': bloodType,
      };
}

// class UserMode {
//   final String? id;
//   final String? name;
//   final String? email;
//   final String? password;
//   final String? confirmPassword;
//   final String? phoneNo;

//   const UserMode(
//       {this.id,
//       required this.name,
//       required this.email,
//       required this.password,
//       required this.confirmPassword,
//       required this.phoneNo});

//   toJson() {
//     return {
//       "Name": name,
//       "Email": email,
//       "Password": password,
//       "Confirm password": confirmPassword,
//       "PhoneNumber": phoneNo,
//     };
//   }

// }