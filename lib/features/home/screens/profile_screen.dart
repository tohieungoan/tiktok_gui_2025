import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Danh sách URL ảnh cho từng icon
  final List<List<String>> imageUrls = [
    [
      // Ảnh khi click vào Icon 1
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
    ],
    [
      // Ảnh khi click vào Icon 2
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
    ],
    [
      // Ảnh khi click vào Icon 3
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
    ],
    [
      // Ảnh khi click vào Icon 4
      "https://picsum.photos/200/300",
    ],
  ];

  // Danh sách ảnh hiển thị hiện tại
  List<String> currentImages = [];

  // Biến để lưu icon đang được chọn
  int selectedIconIndex = 0;

  @override
  void initState() {
    super.initState();
    // Mặc định, khi màn hình load, chọn icon đầu tiên
    currentImages = imageUrls[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.userPlus),
          onPressed: () {
            print("User icon pressed!");
          },
        ),
        title: const Text("Tô Hiếu Ngoan"),
        actions: [
          IconButton(
            onPressed: () {
              print("Setting 1 pressed!");
            },
            icon: const FaIcon(FontAwesomeIcons.gear),
          ),
          IconButton(
            onPressed: () {
              print("More pressed!");
            },
            icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AvatarWidget(),
          const SizedBox(height: 10),
          const Text("@Ngoan.ToHieu"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "100", // Số lượng follow
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text("Đã follow"),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    "200", // Số lượng follow
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text("Follow"),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    "300", // Số lượng thích
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text("Thích"),
                ],
              ),
              IconButton(
                onPressed: () {
                  print("Edit button pressed!");
                },
                icon: const FaIcon(FontAwesomeIcons.edit),
              ),
            ],
          ),
          const SizedBox(height: 10),

          const Text("Tiểu sử"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(FontAwesomeIcons.solidHeart, 0), // Icon 1
              const SizedBox(width: 20),
              _buildIconButton(FontAwesomeIcons.commentDots, 1), // Icon 2
              const SizedBox(width: 20),
              _buildIconButton(FontAwesomeIcons.share, 2), // Icon 3
              const SizedBox(width: 20),
              _buildIconButton(FontAwesomeIcons.bookmark, 3), // Icon 4
            ],
          ),
          const SizedBox(height: 10),
          // Dùng GridView để hiển thị ảnh
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Số ảnh trên mỗi hàng
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount:
                  currentImages
                      .length, // Sử dụng số lượng ảnh trong currentImages
              itemBuilder: (context, index) {
                return Image.network(currentImages[index], fit: BoxFit.cover);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Hàm xây dựng icon button
  Widget _buildIconButton(IconData icon, int index) {
    // Kiểm tra nếu icon này được chọn, sẽ thay đổi màu sắc
    bool isSelected = index == selectedIconIndex;
    return GestureDetector(
      onTap: () {
        _changeImages(index);
      },
      child: Column(
        children: [
          FaIcon(
            icon,
            color:
                isSelected
                    ? Colors.yellow
                    : Colors.black, // Đổi màu nếu được chọn
          ),
          Text(
            'Icon ${index + 1}',
            style: TextStyle(color: isSelected ? Colors.yellow : Colors.black),
          ),
        ],
      ),
    );
  }

  // Hàm thay đổi ảnh theo icon được nhấn
  void _changeImages(int index) {
    setState(() {
      selectedIconIndex = index; // Lưu lại icon được chọn
      currentImages = imageUrls[index]; // Lấy danh sách ảnh theo index của icon
    });
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              "https://marketplace.canva.com/b0LFw/MAFW8jb0LFw/1/tl/canva-boy-avatar-illustration-set-collection-MAFW8jb0LFw.png",
            ),
          ),
          const EditIconButton(),
        ],
      ),
    );
  }
}

class EditIconButton extends StatelessWidget {
  const EditIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.penToSquare,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () {
            print("Edit avatar pressed!");
          },
        ),
      ),
    );
  }
}
