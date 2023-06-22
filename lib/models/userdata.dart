class UserDataModel {
  late String firstName;
  late String lastName;
  late String email;
  String? imagePath;
  UserDataModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      this.imagePath});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    imagePath = json['imagePath'];
  }
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'imagePath': imagePath
    };
  }
}

class CoachBillingModel {
  late String athlete;
  late String totlaDays;
  late String email;
  CoachBillingModel(
      {required this.athlete, required this.totlaDays, required this.email});

  CoachBillingModel.fromJson(Map<String, dynamic> json) {
    athlete = json['athlete'] ?? "";
    totlaDays = json['totalDays'] ?? "";
    email = json['email'] ?? "";
  }
  Map<String, dynamic> toMap() {
    return {'athlete': athlete, 'totalDays': totlaDays, 'email': email};
  }
}

class ManageBillingModel {
  String? id;
  String? address1;
  String? address2;
  String? cardNum;
  String? city;
  String? country;
  String? postalNum;

  ManageBillingModel(
      {required this.id,
      required this.address1,
      required this.address2,
      required this.cardNum,
      required this.city,
      required this.country,
      required this.postalNum});

  ManageBillingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address1 = json['address1'];
    address2 = json['address2'];
    cardNum = json['cardNum'];
    city = json['city'];
    country = json['country'];
    postalNum = json['postalNum'];
  }

  Map<String, dynamic> toMap() {
    return {
      'address1': address1,
      'id': id,
      'address2': address2,
      'cardNum': cardNum,
      'city': city,
      'country': country,
      'postalNum': postalNum,
    };
  }
}
