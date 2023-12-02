class PromptsModel {
  List<Nudges>? nudges;

  PromptsModel({this.nudges});

  PromptsModel.fromJson(Map<String, dynamic> json) {
    if (json['nudges'] != null) {
      nudges = <Nudges>[];
      json['nudges'].forEach((v) {
        nudges!.add(Nudges.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (nudges != null) {
      data['nudges'] = nudges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Nudges {
  int? id;
  String? question;

  Nudges({this.id, this.question});

  Nudges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    return data;
  }
}
