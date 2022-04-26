import 'package:co2fzs/models/article.dart';
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  const ArticleDetailScreen({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Image.network(article.photoUrl),
                SizedBox(height: 12),
                Text(article.title,
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(height: 12),
                Text(article.text),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
