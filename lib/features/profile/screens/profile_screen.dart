import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_app/blocs/user/user_bloc.dart';
import 'package:tiktok_app/features/profile/widgets/avatar_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<List<String>> imageUrls = [
    [
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
    ],
    [
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
    ],
    [
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
    ],
    [
      "https://picsum.photos/200/300",
    ],
  ];

  List<String> currentImages = [];
  int selectedIconIndex = 0;

  @override
  void initState() {
    super.initState();
    currentImages = imageUrls[0];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial) {
          final user = state.user;

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: const FaIcon(FontAwesomeIcons.userPlus),
                onPressed: () {
                  print("User icon pressed!");
                },
              ),
              title: Text(user.username.toString()), // Lấy từ bloc
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
                AvatarWidget(user.avatar.toString()), // Truyền đúng avatarUrl
                const SizedBox(height: 10),
                Text("@${user.username}"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text("100", style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text("Đã follow"),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text("200", style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text("Follow"),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Text("300", style: TextStyle(fontWeight: FontWeight.bold)),
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
                Text(
                  user.bio?.isNotEmpty == true ? user.bio! : "Tiểu sử đang cập nhật...",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIconButton(FontAwesomeIcons.solidHeart, 0),
                    const SizedBox(width: 20),
                    _buildIconButton(FontAwesomeIcons.commentDots, 1),
                    const SizedBox(width: 20),
                    _buildIconButton(FontAwesomeIcons.share, 2),
                    const SizedBox(width: 20),
                    _buildIconButton(FontAwesomeIcons.bookmark, 3),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: currentImages.length,
                    itemBuilder: (context, index) {
                      return Image.network(currentImages[index], fit: BoxFit.cover);
                    },
                  ),
                ),
              ],
            ),
          );
        }

        // Nếu chưa load user, hiển thị loading
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildIconButton(IconData icon, int index) {
    bool isSelected = index == selectedIconIndex;
    return GestureDetector(
      onTap: () => _changeImages(index),
      child: Column(
        children: [
          FaIcon(icon, color: isSelected ? Colors.yellow : Colors.black),
          Text(
            'Icon ${index + 1}',
            style: TextStyle(color: isSelected ? Colors.yellow : Colors.black),
          ),
        ],
      ),
    );
  }

  void _changeImages(int index) {
    setState(() {
      selectedIconIndex = index;
      currentImages = imageUrls[index];
    });
  }
}
