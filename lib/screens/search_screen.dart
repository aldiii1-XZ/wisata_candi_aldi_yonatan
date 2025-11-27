import 'package:flutter/material.dart';
import '../models/candi.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Candi> _filteredCandis = List.from(candiList);

  void _filterCandis(String query) {
    final filtered = candiList.where((candi) {
      final search = query.toLowerCase();
      return candi.name.toLowerCase().contains(search) ||
          candi.location.toLowerCase().contains(search) ||
          candi.type.toLowerCase().contains(search);
    }).toList();

    setState(() {
      _filteredCandis = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Candi'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: _controller,
                onChanged: _filterCandis,
                decoration: const InputDecoration(
                  hintText: 'Cari candi ...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCandis.length,
              itemBuilder: (context, index) {
                final candi = _filteredCandis[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        candi.imageAsset,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      candi.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${candi.location}\n${candi.type}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(
                        candi.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            candi.isFavorite ? Colors.red : Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          candi.isFavorite = !candi.isFavorite;
                        });
                      },
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(candi.name),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(candi.imageAsset),
                                const SizedBox(height: 8),
                                Text(
                                  candi.description,
                                  textAlign: TextAlign.justify,
                                ),
                                const SizedBox(height: 8),
                                Text('Dibangun: ${candi.built}'),
                                Text('Tipe: ${candi.type}'),
                                Text('Lokasi: ${candi.location}'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
