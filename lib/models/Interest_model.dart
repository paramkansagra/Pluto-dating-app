class InterestElement {
  Interests? interests;

  InterestElement({this.interests});

  InterestElement.fromJson(Map<String, dynamic> json) {
    interests = json['interests'] != null
        ? Interests.fromJson(json['interests'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (interests != null) {
      data['interests'] = interests!.toJson();
    }
    return data;
  }
}

class Interests {
  List<String>? selfCare;
  List<String>? sports;
  List<String>? creativity;
  List<String>? goingOut;
  List<String>? filmAndTv;
  List<String>? stayingIn;
  List<String>? reading;
  List<String>? music;
  List<String>? foodAndDrink;
  List<String>? travelling;
  List<String>? pets;
  List<String>? valuesAndTraits;
  List<String>? plutoValuesAndAllyship;

  Interests(
      {this.selfCare,
      this.sports,
      this.creativity,
      this.goingOut,
      this.filmAndTv,
      this.stayingIn,
      this.reading,
      this.music,
      this.foodAndDrink,
      this.travelling,
      this.pets,
      this.valuesAndTraits,
      this.plutoValuesAndAllyship});

  Interests.fromJson(Map<String, dynamic> json) {
    selfCare = json['self_care'].cast<String>();
    sports = json['sports'].cast<String>();
    creativity = json['creativity'].cast<String>();
    goingOut = json['going_out'].cast<String>();
    filmAndTv = json['film_and_tv'].cast<String>();
    stayingIn = json['staying_in'].cast<String>();
    reading = json['reading'].cast<String>();
    music = json['music'].cast<String>();
    foodAndDrink = json['food_and_drink'].cast<String>();
    travelling = json['travelling'].cast<String>();
    pets = json['pets'].cast<String>();
    valuesAndTraits = json['values_and_traits'].cast<String>();
    plutoValuesAndAllyship = json['pluto_values_and_allyship'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['self_care'] = selfCare;
    data['sports'] = sports;
    data['creativity'] = creativity;
    data['going_out'] = goingOut;
    data['film_and_tv'] = filmAndTv;
    data['staying_in'] = stayingIn;
    data['reading'] = reading;
    data['music'] = music;
    data['food_and_drink'] = foodAndDrink;
    data['travelling'] = travelling;
    data['pets'] = pets;
    data['values_and_traits'] = valuesAndTraits;
    data['pluto_values_and_allyship'] = plutoValuesAndAllyship;
    return data;
  }
}
