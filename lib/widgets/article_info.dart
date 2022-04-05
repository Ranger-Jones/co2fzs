import 'package:co2fzs/models/article.dart';
import 'package:flutter/material.dart';

class ArticleInfo extends StatelessWidget {
  final Article snap;
  const ArticleInfo({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(snap.photoUrl,
                loadingBuilder: ((context, child, loadingProgress) => child)),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Text(snap.title),
            Flexible(child: Container(), flex: 1),
            Text(snap.author),
          ])
        ],
      ),
    );
  }
}
