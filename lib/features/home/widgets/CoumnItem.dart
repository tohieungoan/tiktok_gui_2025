import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_app/core/constants.dart';
import 'package:tiktok_app/features/home/screens/Other_Profile.dart';
import 'package:tiktok_app/features/home/widgets/button.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.pushNamed(
            //   context,
            //   '/OtherProfile',
            //   arguments: "ngoanpros213@gmail.comcom",
            // );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OtherProfile(email: 'ngoanpros213@gmail.com'),
              ),
            );
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://image.phunuonline.com.vn/fckeditor/upload/2025/20250302/images/bi-quyet-giup-chuong-nhuoc-_611740908338.jpg",
                ),
                radius: screenHeight * 0.03,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: screenHeight * 0.013,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.add,
                    size: screenHeight * 0.015,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Button(
          onChanged: (liked) {
            print("Đã ${liked ? 'thích' : 'bỏ thích'} video");
          },
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
          icon: FontAwesomeIcons.solidHeart,
        ),
        const SizedBox(height: 8),
        Button(
          onChanged: (liked) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true, // Cho phép điều chỉnh chiều cao
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return FractionallySizedBox(
                  heightFactor: 0.7,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          MediaQuery.of(
                            context,
                          ).viewInsets.bottom, // Đẩy lên khi mở bàn phím
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
                        Expanded(
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder:
                                (context, index) => ListTile(
                                  leading: CircleAvatar(child: Text("U$index")),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Người dùng $index",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text("Bình luận mẫu số $index"),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            "12 phút trước",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print("Trả lời");
                                            },
                                            child: Text("Trả lời"),
                                          ),
                                        ],
                                      ),
                                      if (index == 2)
                                        const Text("Xem tất cả phản hồi"),
                                    ],
                                  ),
                                ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Viết bình luận...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  // Gửi bình luận
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
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
          icon: FontAwesomeIcons.solidCommentDots,
        ),

        const SizedBox(height: 8),
        Button(
          onChanged: (liked) {
            print("Đã ${liked ? 'thích' : 'bỏ thích'} video");
          },
          activeColor: Colors.yellow,
          inactiveColor: Colors.grey,
          icon: FontAwesomeIcons.solidBookmark,
        ),
        const SizedBox(height: 8),
        Button(
          onChanged: (liked) {
            print("Đã ${liked ? 'thích' : 'bỏ thích'} video");
          },
          activeColor: Colors.yellow,
          inactiveColor: Colors.grey,
          icon: FontAwesomeIcons.solidShareFromSquare,
        ),
      ],
    );
  }
}
