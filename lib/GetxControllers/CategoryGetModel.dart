class CategoryGetModel {
  bool? status;
   List<Dataa>? data = [];

  CategoryGetModel({this.status, this.data});

  CategoryGetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
     // data = new List<Data>();
      json['data'].forEach((v) {
        data!.add(new Dataa.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dataa {
  int? id;
  int? level;
  int? parentId;
  String? name;
  int? priority;
  int? status;
  String? image;

  Dataa(
      {this.id,
      this.level,
      this.parentId,
      this.name,
      this.priority,
      this.status,
      this.image});

  Dataa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    parentId = json['parent_id'];
    name = json['name'];
    priority = json['priority'];
    status = json['status'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['level'] = this.level;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['image'] = this.image;
    return data;
  }
}