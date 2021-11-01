
class SettingsModel {
  String? phone;
  String? email;
  String? in_app_purchase_id;
  String? facebook;
  String? twitter;
  String? youtube;
  String? linkedin;
  String? pinterest;
  String? instagram;

  SettingsModel({
    this.phone,
    this.email,
    this.in_app_purchase_id,
    this.facebook,
    this.twitter,
    this.youtube,
    this.linkedin,
    this.pinterest,
    this.instagram,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    phone: json["phone"] == null ? null : json["phone"],
    in_app_purchase_id: json["in_app_purchase_id"] == null ? null : json["in_app_purchase_id"],
    email: json["email"] == null ? null : json["email"],
    facebook: json["facebook"] == null ? null : json["facebook"],
    twitter: json["twitter"] == null ? null : json["twitter"],
    youtube: json["youtube"] == null ? null : json["youtube"],
    linkedin: json["linkedin"] == null ? null : json["linkedin"],
    pinterest: json["pinterest"] == null ? null : json["pinterest"],
    instagram: json["instagram"] == null ? null : json["instagram"],
  );

}
