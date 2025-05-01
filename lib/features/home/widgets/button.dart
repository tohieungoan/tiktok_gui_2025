import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/home/controllers/ApiLike.dart';
import 'package:tiktok_app/features/home/controllers/PostController.dart';
import 'package:tiktok_app/models/Post.dart';
class Button extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final IconData? icon;
  final String type; // like, comment, or share
  final Post post;

  const Button({
    super.key,
    this.onChanged,
    this.activeColor = Colors.red,
    this.inactiveColor = AppColors.xamtrang,
    this.icon = FontAwesomeIcons.solidHeart,
    required this.type,
    required this.post,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late final PostController postController;

  @override
  void initState() {
    super.initState();
    postController = Get.find<PostController>();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() {
          final isLiked = widget.post.isLiked.value;
          return IconButton(
            onPressed: () async {
              if (widget.type == "like") {
                if (!isLiked) {
                  widget.post.isLiked.value = true;
                  postController.toggleLike(widget.post);
                  await ApiLike.createLike(
                    context: context,
                    iduser: widget.post.user?.id.toString() ?? "",
                    idpost: widget.post.id.toString(),
                  );
                } else {
                  await ApiLike.deleteLike(
                    context: context,
                    idpost: widget.post.id.toString(),
                  );
                  widget.post.isLiked.value = false;
                  postController.decreaseLike(widget.post);
                }
              }

              if (widget.type == "share") {
                widget.post.sharesCount.value =
                    widget.post.sharesCount.value == 0
                        ? widget.post.sharesCount.value + 1
                        : widget.post.sharesCount.value - 1;
              }

              if (widget.onChanged != null) {
                widget.onChanged!(widget.post.likesCount.value > 0);
              }
            },
            icon: FaIcon(
              widget.icon ?? FontAwesomeIcons.solidHeart,
              color: widget.type == "like"
                  ? (isLiked ? widget.activeColor : widget.inactiveColor)
                  : widget.inactiveColor,
              size: screenHeight * 0.04,
            ),
          );
        }),

        Obx(() {
          final count = widget.type == "like"
              ? widget.post.likesCount.value
              : widget.type == "comment"
                  ? widget.post.commentsCount.value
                  : widget.post.sharesCount.value;

          return Text(
            '$count',
            style: TextStyle(
              fontSize: screenHeight * 0.02,
              fontWeight: FontWeight.bold,
              color: widget.inactiveColor,
            ),
          );
        }),
      ],
    );
  }
}
