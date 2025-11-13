import 'package:flutter/material.dart';

class DetailHeader extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onBackPressed;

  const DetailHeader({
    super.key,
    required this.imageUrl,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // gambar utama dengan tinggi tetap & full lebar
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 250,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
              ),
            ),
          ),
        ),

        // tombol back di atas gambar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: CircleAvatar(
              backgroundColor: Colors.white70,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
                onPressed: onBackPressed,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
