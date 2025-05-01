import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/features/home/controllers/ApiComment.dart';
import 'package:tiktok_app/features/home/controllers/CommentController.dart';
import 'package:tiktok_app/features/home/controllers/PostController.dart';
import 'package:tiktok_app/features/home/screens/Other_Profile.dart';
import 'package:tiktok_app/features/home/widgets/button.dart';
import 'package:tiktok_app/features/profile/controller/get_current_user_by_token.dart';
import 'package:tiktok_app/models/Post.dart';
import 'package:tiktok_app/models/Comment.dart';
import 'package:tiktok_app/models/User.dart';

class ListItem extends StatelessWidget {
  final Post currentPost;

  const ListItem(this.currentPost, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController commentTextController = TextEditingController();
    final CommentController commentController = Get.find<CommentController>();
    final PostController postController = Get.find<PostController>();

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            Userapp? user = await GetUserByToken.getUserById(
              currentPost.user?.id.toString() ?? "",
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        user != null
                            ? OtherProfile(user: user)
                            : const SizedBox.shrink(),
              ),
            );
          },
          child: Obx(() {
            return Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage("${currentPost.user?.avatar}"),
                  radius: screenHeight * 0.03,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: screenHeight * 0.013,
                    backgroundColor:
                        postController.isFollow.value
                            ? Colors.cyanAccent
                            : Colors.red,
                    child: Icon(
                      postController.isFollow.value ? Icons.check : Icons.add,
                      size: screenHeight * 0.015,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 8),
        Button(
          onChanged: (liked) {
            print("Đã ${liked ? 'thích' : 'bỏ thích'} video");
          },
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
          icon: FontAwesomeIcons.solidHeart,
          type: "like", // Specify the type as "like"
          post: currentPost, // Pass the currentPost to update it
        ),
        const SizedBox(height: 8),
        Button(
          onChanged: (liked) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                commentController.fetchCommentsFromApi(
                  currentPost.id.toString(),
                  context,
                );
                return FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Bình luận",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),

                        // Observe the comments from the CommentController
                        Obx(() {
                          final comments = commentController.mainComments;

                          return Expanded(
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return Obx(() {
                                  final comment = comments[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        comment.user!.avatar.toString(),
                                      ),
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.user!.firstname.toString() +
                                                  " " +
                                                  comment.user!.lastname
                                                      .toString() ??
                                              'Unknown User',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(comment.content ?? "No content"),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              timeAgoSinceDate(
                                                DateTime.parse(
                                                  comment.createAt ?? '',
                                                ),
                                              ),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                FocusScope.of(
                                                  context,
                                                ).requestFocus(
                                                  commentController
                                                      .commentFocusNode,
                                                );
                                                if (commentController
                                                        .isreply
                                                        .value ==
                                                    false) {
                                                  final username =
                                                      comment.user?.firstname ??
                                                      "người dùng";
                                                  commentController
                                                          .replyHintText
                                                          .value =
                                                      "Trả lời @$username";
                                                  commentController
                                                          .idcommentreply
                                                          .value =
                                                      comment.id.toString();
                                                  commentController
                                                          .isreply
                                                          .value =
                                                      !commentController
                                                          .isreply
                                                          .value;
                                                } else {
                                                  commentTextController
                                                      .clear(); // Clear input after sending
                                                  commentController
                                                          .replyHintText
                                                          .value =
                                                      "Viết bình luận...";
                                                  commentController
                                                      .commentFocusNode
                                                      .unfocus();
                                                  commentController
                                                      .idcommentreply
                                                      .value = '';
                                                  commentController
                                                          .isreply
                                                          .value =
                                                      !commentController
                                                          .isreply
                                                          .value;
                                                }
                                              },
                                              child: const Text("Trả lời"),
                                            ),
                                          ],
                                        ),
                                        if (commentController.getRepliesCount(
                                              comment.id!,
                                            ) >
                                            0)
                                          GestureDetector(
                                            onTap: () {
                                              commentController.toggleReplies(
                                                comment.id!,
                                                context,
                                              );
                                            },
                                            child: Text(
                                              commentController
                                                          .showRepliesMap[comment
                                                          .id!] ==
                                                      true
                                                  ? "Ẩn phản hồi"
                                                  : "Xem tất cả phản hồi (${commentController.getRepliesCount(comment.id!)})",
                                              style: const TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        if (commentController
                                                .showRepliesMap[comment.id!] ==
                                            true)
                                          Column(
                                            children:
                                                commentController
                                                    .getReplies(comment.id!)
                                                    .map(
                                                      (reply) => Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 40.0,
                                                            ),
                                                        child: ListTile(
                                                          leading: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                  reply
                                                                          .user
                                                                          ?.avatar ??
                                                                      "",
                                                                ),
                                                          ),
                                                          title: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${reply.user?.firstname ?? 'Unknown'} ${reply.user?.lastname ?? ''}",
                                                                style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),

                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                reply.content ??
                                                                    "",
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                timeAgoSinceDate(
                                                                  DateTime.parse(
                                                                    reply.createAt ??
                                                                        '',
                                                                  ),
                                                                ),
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .grey[600],
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                      ],
                                    ),
                                  );
                                });
                              },
                            ),
                          );
                        }),

                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => TextField(
                                    controller: commentTextController,
                                    focusNode:
                                        commentController.commentFocusNode,
                                    decoration: InputDecoration(
                                      hintText:
                                          commentController.replyHintText.value,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () async {
                                  String content =
                                      commentTextController.text.trim();

                                  if (content.isNotEmpty) {
                                    if (commentController.isreply.value ==
                                        true) {
                                      await ApiComments.CreateComment(
                                        context: context,
                                        parent_comment:
                                            commentController
                                                .idcommentreply
                                                .value,

                                        idpost: currentPost.id.toString(),
                                        currentPost: currentPost,
                                        content: content,
                                      );
                                    } else {
                                      await ApiComments.CreateComment(
                                        context: context,
                                        idpost: currentPost.id.toString(),
                                        currentPost: currentPost,
                                        content: content,
                                      );
                                    }
                                    commentController.fetchCommentsFromApi(
                                      currentPost.id.toString(),
                                      context,
                                    );
                                    commentTextController
                                        .clear(); // Clear input after sending
                                    commentController.replyHintText.value =
                                        "Viết bình luận...";
                                    commentController.commentFocusNode
                                        .unfocus();
                                    commentController.idcommentreply.value = '';
                                    commentController.isreply.value = false;
                                    // nếu bạn dùng biến này
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Vui lòng nhập bình luận",
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          activeColor: Colors.grey,
          inactiveColor: Colors.grey,
          icon: FontAwesomeIcons.solidCommentDots,
          type: "comment", // Specify the type as "comment"
          post: currentPost, // Pass the currentPost to update it
        ),
        const SizedBox(height: 8),
        Button(
          onChanged: (liked) {
            print("Đã ${liked ? 'thích' : 'bỏ thích'} video");
          },
          activeColor: Colors.yellow,
          inactiveColor: Colors.grey,
          icon: FontAwesomeIcons.solidBookmark,
          type: "save", // Specify the type as "save"
          post: currentPost, // Pass the currentPost to update it
        ),
        const SizedBox(height: 8),
        Button(
          onChanged: (liked) {
            print("Đã ${liked ? 'thích' : 'bỏ thích'} video");
          },
          activeColor: Colors.yellow,
          inactiveColor: Colors.grey,
          icon: FontAwesomeIcons.solidShareFromSquare,
          type: "share", // Specify the type as "share"
          post: currentPost, // Pass the currentPost to update it
        ),
      ],
    );
  }

  String timeAgoSinceDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} giây trước';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} tuần trước';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else {
      return '${(difference.inDays / 365).floor()} năm trước';
    }
  }
}
