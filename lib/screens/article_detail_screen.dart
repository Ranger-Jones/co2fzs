import 'package:co2fzs/models/article.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                Container(
                    width: kIsWeb
                        ? MediaQuery.of(context).size.width * 0.4
                        : double.infinity,
                    child: ClipRRect(child: Image.network(article.photoUrl))),
                SizedBox(height: 12),
                Text(article.title,
                    style: Theme.of(context).textTheme.headline3),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.person),
                    Text(
                      article.author == "SuperAdmin"
                          ? "CO2-frei zur Schule Team"
                          : article.author,
                    )
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.date_range),
                    Text(
                      DateFormat.yMMMEd()
                          .format(article.datePublished.toDate())
                          .toString(),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Divider(height: 3),
                SizedBox(height: 12),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(article.text)),
                SizedBox(height: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
