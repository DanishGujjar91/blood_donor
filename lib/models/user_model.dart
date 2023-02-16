class UserMode {
  final String? name;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? phoneNo;
  final String? image;
  UserMode({
    required this.image,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNo,
  });

  UserMode.fromJson(
    Map<String, dynamic> json,
  )   : image = json['image'],
        name = json['name'],
        email = json['email'],
        password = json['password'],
        confirmPassword = json['confirmPassword'],
        phoneNo = json['phoneNo'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'phoneNo': phoneNo,
        'image': image,
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