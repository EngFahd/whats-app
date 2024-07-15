class ChatUserModel {
  ChatUserModel({
    required this.isOnline,
    required this.id,
    required this.pushToken,
    required this.createdAt,
    required this.image,
    required this.about,
    required this.lastActive,
    required this.name,
  });
  late final bool isOnline;
  late final String pushToken;
  late final String id;
  late final String createdAt;
  late final String image;
  late final String about;
  late final String lastActive;
  late final String name;
  
  ChatUserModel.fromJson(json){
    isOnline = json['is_online'];
    pushToken = json['push_token'];
    createdAt = json['created_at'];
    image = json['image'];
    about = json['about'];
    lastActive = json['last_active'];
    name = json['name'];
    id = json['id'];
  }

  Map<String , dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_online'] = isOnline;
    data['push_token'] = pushToken;
    data['created_at'] = createdAt;
    data['image'] = image;
    data['about'] = about;
    data['last_active'] = lastActive;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}