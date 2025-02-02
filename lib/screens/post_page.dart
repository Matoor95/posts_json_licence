import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:posts_json/models/post.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  // Future qui retournera la liste de posts
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = _loadPosts();
  }

  // Méthode pour charger le JSON depuis les assets
  Future<List<Post>> _loadPosts() async {
    // On récupère le contenu brut du fichier JSON
    final String response =
        await rootBundle.loadString('assets/data/posts.json');
    // On décode le contenu en liste dynamique
    final List<dynamic> data = jsonDecode(response);
    // On convertit chaque élément en objet Post
    return data.map((json) => Post.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Liste de Posts'),
        ),
        body: FutureBuilder<List<Post>>(
          future: futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Erreur lors du chargement des données');
            }  else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Aucun donnee disponible'));
            } else {
              final posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(post.title),
                          subtitle: Text(post.content),
                        ),
                  );
                },
              );
            }
          },
        ));
  }
}
