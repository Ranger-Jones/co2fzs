import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/article.dart';
import 'package:co2fzs/widgets/article_info.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, top: 75),
            child: Column(
              children: [
                Text(
                  "Neuigkeiten",
                  style: Theme.of(context).textTheme.headline1,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("articles")
                      .orderBy("datePublished")
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Divider(),
                            ArticleInfo(
                              snap: Article.fromSnap(
                                snapshot.data!.docs[index],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
