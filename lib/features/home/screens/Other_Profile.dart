import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_app/core/constants.dart';

class OtherProfile extends StatefulWidget {
  final String email;

  const OtherProfile({super.key, required this.email});

  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  // Danh sách ảnh
  final List<String> imageUrls = [
    "https://picsum.photos/id/1011/200/300",
    "https://picsum.photos/id/1012/200/300",
    "https://picsum.photos/id/1013/200/300",
    "https://picsum.photos/id/1014/200/300",
    "https://picsum.photos/id/1015/200/300",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.leftLong),
          onPressed: () {
            Navigator.pop(context); // Trở về màn hình trước
          },
        ),
        title: const Text("Tô Hiếu Ngoan"),
        actions: [
          IconButton(
            onPressed: () {
              print("Bell icon pressed!");
            },
            icon: const FaIcon(FontAwesomeIcons.bell),
          ),
          IconButton(
            onPressed: () {
              print("Share icon pressed!");
            },
            icon: const FaIcon(FontAwesomeIcons.share),
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
              _buildStatColumn("100", "Đã follow"),
              const SizedBox(width: 20),
              _buildStatColumn("200", "Follow"),
              const SizedBox(width: 20),
              _buildStatColumn("300", "Thích"),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.dohong,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Follow",
                  style: TextStyle(color: AppColors.trang),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.trang,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Nhắn tin",
                  style: TextStyle(color: AppColors.den),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Tiểu sử"),
          const SizedBox(height: 10),

          // Hiển thị ảnh
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(imageUrls[index], fit: BoxFit.cover);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
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
