import 'package:flutter/material.dart';
import 'package:nike_store/data/comment.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({Key? key, required this.comment}) : super(key: key);
  final CommentEntity comment;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: themeData.dividerColor, width: 1),
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(comment.title),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    comment.email,
                    style: themeData.textTheme.caption,
                  ),
                ],
              ),
              Text(comment.date, style: themeData.textTheme.caption),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            comment.content,
            style: const TextStyle(height: 1.4),
          )
        ],
      ),
    );
  }
}
