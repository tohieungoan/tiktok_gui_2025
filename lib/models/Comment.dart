import 'package:tiktok_app/models/User.dart';

class Comment {
  String? id;
  Userapp? user;
  String? parentCommentId;
  String? content;
  bool? isLiked;
  int? likesCount;
  String? createAt;
  String? updatedAt;

  Comment(
      {this.id,
      this.user,
      this.parentCommentId,
      this.content,
      this.isLiked,
      this.likesCount,
      this.createAt,
      this.updatedAt});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new Userapp.fromJson(json['user']) : null;
    parentCommentId = json['parent_comment_id'];
    content = json['content'];
    isLiked = json['is_liked'];
    likesCount = json['likes_count'];
    createAt = json['create_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['parent_comment_id'] = this.parentCommentId;
    data['content'] = this.content;
    data['is_liked'] = this.isLiked;
    data['likes_count'] = this.likesCount;
    data['create_at'] = this.createAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

