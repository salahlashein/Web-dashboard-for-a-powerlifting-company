class UserDataModel {
  late String firstName;
  late String lastName;
  late String email;
  UserDataModel(
      {required this.firstName, required this.lastName, required this.email});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
  }
  Map<String, dynamic> toMap() {
    return {'firstName': firstName, 'lastName': lastName, 'email': email};
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
  String? address1;
  String? address2;
  String? cardNum;
  String? city;
  String? country;
  String? postalNum;

  ManageBillingModel(
      {this.address1,
      this.address2,
      this.cardNum,
      this.city,
      this.country,
      this.postalNum});

  ManageBillingModel.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    cardNum = json['cardNum'];
    city = json['city'];
    country = json['country'];
    postalNum = json['postalNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['cardNum'] = this.cardNum;
    data['city'] = this.city;
    data['country'] = this.country;
    data['postalNum'] = this.postalNum;
    return data;
  }
}
