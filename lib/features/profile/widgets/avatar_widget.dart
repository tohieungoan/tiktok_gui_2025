import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AvatarWidget extends StatelessWidget {
  final String avatarUrl;

  const AvatarWidget(this.avatarUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(avatarUrl),
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
          icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 18, color: Colors.black),
          onPressed: () {
            print("Edit avatar pressed!");
          },
        ),
      ),
    );
  }
}
