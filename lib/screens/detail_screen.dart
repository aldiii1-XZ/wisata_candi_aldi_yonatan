import 'package:flutter/material.dart';
import '/models/candi.dart';
import '/widgets/detail_gallery.dart';
import '/widgets/detail_header.dart';
import '/widgets/detail_info.dart';
import '../services/auth_service.dart';

class DetailScreen extends StatefulWidget {
  final Candi candi;
  const DetailScreen({super.key, required this.candi});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.candi.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHeader(
              imageUrl: widget.candi.imageUrls.isNotEmpty
                  ? widget.candi.imageUrls.first
                  : null,
              onBackPressed: () => Navigator.pop(context),
            ),
            DetailInfo(
              candi: widget.candi,
              isFavorite: isFavorite,
              onToggleFavorite: toggleFavorite,
            ),
            DetailGallery(imageUrls: widget.candi.imageUrls),
          ],
        ),
      ),
    );
  }

  void toggleFavorite() {
    if (!AuthService.instance.isSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masuk terlebih dahulu untuk menambahkan favorit.'),
        ),
      );
      return;
    }
    final nowFavorite = AuthService.instance.toggleFavorite(widget.candi.name);
    setState(() {
      isFavorite = nowFavorite;
      widget.candi.isFavorite = nowFavorite;
    });
  }
}
