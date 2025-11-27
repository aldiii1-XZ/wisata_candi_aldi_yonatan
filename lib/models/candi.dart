// 📁 lib/data/candi_data.dart
class Candi {
  final String name;
  final String location;
  final String description;
  final String built;
  final String type;
  final String imageAsset;
  final List<String> imageUrls;
  bool isFavorite;

  Candi({
    required this.name,
    required this.location,
    required this.description,
    required this.built,
    required this.type,
    required this.imageAsset,
    required this.imageUrls,
    this.isFavorite = false,
  });
}

final List<Candi> candiList = [
  Candi(
    name: 'Candi Borobudur',
    location: 'Magelang, Jawa Tengah',
    description:
        'Candi Buddha terbesar di dunia dan merupakan salah satu warisan budaya dunia UNESCO.',
    built: 'Abad ke-8 M',
    type: 'Buddha',
    imageAsset: 'assets/images/borobudur.jpg',
    imageUrls: [
      'https://upload.wikimedia.org/wikipedia/commons/9/91/Borobudur-Nothwest-view.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/0/0e/Borobudur_stupa.jpg',
    ],
  ),
  Candi(
    name: 'Candi Prambanan',
    location: 'Sleman, Yogyakarta',
    description:
        'Candi Hindu terbesar di Indonesia yang dipersembahkan untuk Trimurti: Brahma, Wisnu, dan Siwa.',
    built: 'Abad ke-9 M',
    type: 'Hindu',
    imageAsset: 'assets/images/prambanan.jpg',
    imageUrls: [
      'https://upload.wikimedia.org/wikipedia/commons/d/d4/Prambanan_Temple.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/4/4a/Prambanan_Temple_Complex.jpg',
    ],
  ),
  Candi(
    name: 'Candi Mendut',
    location: 'Magelang, Jawa Tengah',
    description:
        'Candi Buddha yang menjadi bagian dari tiga candi besar di kawasan Borobudur.',
    built: 'Abad ke-9 M',
    type: 'Buddha',
    imageAsset: 'assets/images/mendut.jpg',
    imageUrls: [
      'https://upload.wikimedia.org/wikipedia/commons/9/9b/Mendut_Temple.jpg',
    ],
  ),
];
