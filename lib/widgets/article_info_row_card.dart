import 'package:auto_size_text/auto_size_text.dart';
import 'package:co2fzs/models/article.dart';
import 'package:flutter/material.dart';

class ArticleInfoRowCard extends StatelessWidget {
  final Article article;

  const ArticleInfoRowCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.2,
      width: MediaQuery.of(context).size.width * 0.42,
      child: Column(
        children: [
          
          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: Image.network(article.photoUrl, fit: BoxFit.fitWidth),
          ),
          SizedBox(height: 10),
          AutoSizeText(
            article.title,
            maxLines: 2,
            minFontSize: 10,
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    );
  }
}
