class ProfileCreationModel {
  String? firstName;
  String? lastName;
  bool? isVerified;
  bool? isPremium;
  String? dateOfBirth;
  String? gender;
  String? sexualOrientation;
  Education? education;
  double? latitude;
  double? longitude;
  String? occupation;
  String? maritalStatus;
  String? religion;
  int? height;
  int? weight;
  String? lookingFor;
  String? exercise;
  String? drink;
  String? smoke;
  String? about;

  ProfileCreationModel(
      {this.firstName,
      this.lastName,
      this.isVerified,
      this.isPremium,
      this.dateOfBirth,
      this.gender,
      this.sexualOrientation,
      this.education,
      this.latitude,
      this.longitude,
      this.occupation,
      this.maritalStatus,
      this.religion,
      this.height,
      this.weight,
      this.lookingFor,
      this.exercise,
      this.drink,
      this.smoke,
      this.about});

  ProfileCreationModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    isVerified = json['is_verified'];
    isPremium = json['is_premium'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    sexualOrientation = json['sexual_orientation'];
    education = json['education'] != null
        ? Education.fromJson(json['education'])
        : Education(
            educationLevel: null,
            college: null,
          );
    latitude = json['latitude'];
    longitude = json['longitude'];
    occupation = json['occupation'];
    maritalStatus = json['marital_status'];
    religion = json['religion'];
    height = json['height'];
    weight = json['weight'];
    lookingFor = json['looking_for'];
    exercise = json['exercise'];
    drink = json['drink'];
    smoke = json['smoke'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['is_verified'] = isVerified;
    data['is_premium'] = isPremium;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['sexual_orientation'] = sexualOrientation;
    if (education != null) {
      data['education'] = education!.toJson();
    } else {
      education = Education(
        educationLevel: null,
        college: null,
      );
      data['education'] = education!.toJson();
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['occupation'] = occupation;
    data['marital_status'] = maritalStatus;
    data['religion'] = religion;
    data['height'] = height;
    data['weight'] = weight;
    data['looking_for'] = lookingFor;
    data['exercise'] = exercise;
    data['drink'] = drink;
    data['smoke'] = smoke;
    data['about'] = about;
    return data;
  }
}

class Education {
  String? educationLevel;
  String? college;

  Education({this.educationLevel, this.college});

  Education.fromJson(Map<String, dynamic> json) {
    educationLevel = json['education_level'];
    college = json['college'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['education_level'] = educationLevel;
    data['college'] = college;
    return data;
  }
}
