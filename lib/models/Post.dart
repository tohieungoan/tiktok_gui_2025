import 'package:get/get.dart';
import 'package:tiktok_app/models/User.dart';

class Post {
  String? id;
  Userapp? user;
  String? media;
  String? description;
  String? createdAt;
  String? updatedAt;
  RxInt likesCount = 0.obs;
  RxInt commentsCount = 0.obs;
  RxInt sharesCount = 0.obs;
  RxBool isLiked = false.obs; 

  Post({
    this.id,
    this.user,
    this.media,
    this.description,
    this.createdAt,
    this.updatedAt,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isLiked,
  }) {
    this.likesCount.value = likesCount ?? 0;
    this.commentsCount.value = commentsCount ?? 0;
    this.sharesCount.value = sharesCount ?? 0;
    this.isLiked.value = isLiked ?? false;
  }

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? Userapp.fromJson(json['user']) : null;
    media = json['media'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    likesCount.value = json['likes_count'] ?? 0;  // Sử dụng RxInt
    commentsCount.value = json['comments_count'] ?? 0;  // Sử dụng RxInt
    sharesCount.value = json['shares_count'] ?? 0;  // Sử dụng RxInt
    isLiked.value = json['is_liked'] ?? false;  // Sử dụng RxBool
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['media'] = media;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['likes_count'] = likesCount.value;  // Sử dụng .value khi truy xuất
    data['comments_count'] = commentsCount.value;  // Sử dụng .value khi truy xuất
    data['shares_count'] = sharesCount.value;  // Sử dụng .value khi truy xuất
    data['is_liked'] = isLiked.value;  // Sử dụng .value khi truy xuất
    return data;
  }
}
