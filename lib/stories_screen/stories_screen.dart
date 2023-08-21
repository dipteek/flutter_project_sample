import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryScreen extends StatefulWidget {
  String imageUrl;
  StoryScreen({super.key, required this.imageUrl});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final _storyController = StoryController();
  @override
  Widget build(BuildContext context) {
    String url;
    final controller = StoryController();
    final List<StoryItem> storyItem = [
      //StoryItem.pageImage(url: widget.imageUrl, controller: controller),
      //StoryItem.inlineProviderImage(NetworkImage(widget.imageUrl)),
      StoryItem.inlineImage(url: widget.imageUrl, controller: controller)
      //StoryItem.pageProviderImage(NetworkImage(widget.imageUrl))
      //StoryItem.text(title: 'Hii', backgroundColor: Colors.blueAccent),
    ];
    return Material(
      child: StoryView(
        storyItems: storyItem,
        controller: controller,
        inline: false,
        repeat: false,
        onComplete: () => Navigator.pop(context),
      ),
    );
  }
}
