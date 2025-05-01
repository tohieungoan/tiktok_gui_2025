import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/features/home/controllers/ApiComment.dart';
import 'package:tiktok_app/models/Comment.dart';

class CommentController extends GetxController {
  var mainComments = <Comment>[].obs;
  var replyCommentsMap = <String, List<Comment>>{}.obs;
  var showRepliesMap = <String, bool>{}.obs;
  var isreply = false.obs;
  var idcommentreply = ''.obs;

  final FocusNode commentFocusNode = FocusNode();
  final RxString replyHintText = "Viết bình luận...".obs;

  Future<void> fetchCommentsFromApi(String postId, BuildContext context) async {
    try {
      List<Comment> comments = await ApiComments.GetComment(
        context: context,
        idpost: postId,
      );
      loadAllComments(comments);
    } catch (e) {
      print("Error fetching comments: $e");
    }
  }

  void loadAllComments(List<Comment> allComments) {
    clearAll();
    for (var comment in allComments) {
      if (comment.parentCommentId == null) {
        mainComments.add(comment);
      } else {
        final parentId = comment.parentCommentId!;
        replyCommentsMap[parentId] ??= [];
        replyCommentsMap[parentId]!.add(comment);
      }
    }
  }

  Future<void> toggleReplies(String parentId, BuildContext context) async {
    final isCurrentlyShown = showRepliesMap[parentId] ?? false;

    if (!isCurrentlyShown && (replyCommentsMap[parentId]?.isEmpty ?? true)) {
      // Chỉ fetch nếu chưa có phản hồi trong map
      try {
        List<Comment> replies = getReplies(parentId);
        replyCommentsMap[parentId] = replies;
      } catch (e) {
        print("Failed to fetch replies: $e");
      }
    }

    // Toggle trạng thái hiển thị
    showRepliesMap[parentId] = !isCurrentlyShown;
  }

  List<Comment> getReplies(String parentId) {
    return replyCommentsMap[parentId] ?? [];
  }

  int getRepliesCount(String parentId) {
    return replyCommentsMap[parentId]?.length ?? 0;
  }

  void addComment(Comment comment) {
    if (comment.parentCommentId == null) {
      mainComments.add(comment);
    } else {
      final parentId = comment.parentCommentId!;
      replyCommentsMap[parentId] ??= [];
      replyCommentsMap[parentId]!.add(comment);
    }
  }

  void clearAll() {
    mainComments.clear();
    replyCommentsMap.clear();
    showRepliesMap.clear();
  }
}
