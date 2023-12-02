class ProfileModel {
  Data? data;
  String? message;
  bool? error;

  ProfileModel({this.data, this.message, this.error});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    if (data == null ||
        data!.firstName == null ||
        data!.lastName == null ||
        data!.dateOfBirth == null ||
        data!.gender == null) {
      error = true;
    } else {
      error = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    // data['message'] = message;
    return data['data'];
  }
}

class Data {
  int? iD;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? userId;
  String? firstName;
  String? lastName;
  bool? isVerified;
  bool? isPremium;
  String? dateOfBirth;
  String? gender;
  String? sexualOrientation;
  double? latitude;
  double? longitude;
  String? educationLevel;
  String? college;
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
  String? age;

  Data({
    this.iD,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userId,
    this.firstName,
    this.lastName,
    this.isVerified,
    this.isPremium,
    this.dateOfBirth,
    this.gender,
    this.sexualOrientation,
    this.latitude,
    this.longitude,
    this.educationLevel,
    this.college,
    this.occupation,
    this.maritalStatus,
    this.religion,
    this.height,
    this.weight,
    this.lookingFor,
    this.exercise,
    this.drink,
    this.smoke,
    this.about,
    this.age,
  });

  Data.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    createdAt = json['CreatedAt'];
    updatedAt = json['UpdatedAt'];
    deletedAt = json['DeletedAt'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    isVerified = json['is_verified'];
    isPremium = json['is_premium'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    sexualOrientation = json['sexual_orientation'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    educationLevel = json['education_level'];
    college = json['college'];
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
    age = getAge(dateOfBirth ?? "2003-08-02");
  }

  Map<String, dynamic> toJson() {
    return {
      'id': iD,
      'first_name': firstName,
      'last_name': lastName,
      'is_verified': isVerified,
      'is_premium': isPremium,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'sexual_orientation': sexualOrientation,
      'latitude': latitude,
      'longitude': longitude,
      'education': {
        'education_level': educationLevel,
        'college': college,
      },
      'occupation': occupation,
      'marital_status': maritalStatus,
      'religion': religion,
      'height': height,
      'weight': weight,
      'looking_for': lookingFor,
      'exercise': exercise,
      'drink': drink,
      'smoke': smoke,
      'about': about,
    };
  }

  String getAge(String dateOfBirth) {
    final dateOfBirthFormatted = DateTime.parse(dateOfBirth);
    DateTime currentDate = DateTime.now();

    int age = currentDate.year - dateOfBirthFormatted.year;

    int month1 = currentDate.month;
    int month2 = dateOfBirthFormatted.month;

    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = dateOfBirthFormatted.day;
      if (day2 > day1) {
        age--;
      }
    }

    return age.toString();
  }
}
