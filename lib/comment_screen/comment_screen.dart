import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/comment_screen/commment_function.dart';
import 'package:reel_app/convert.dart';
import 'package:reel_app/loading_screen/loading_screen.dart';
import 'package:reel_app/model_classes/comment_model.dart';
import 'package:reel_app/shared_prefrences/shared_prefrences.dart';

import '../profile_screen/profile_screen_ui_up.dart';

class CommentScreenUI extends StatefulWidget {
  String reelId;
  CommentScreenUI({super.key, required this.reelId});

  @override
  State<CommentScreenUI> createState() => _CommentScreenUIState();
}

class _CommentScreenUIState extends State<CommentScreenUI> {
  List<CommentsModel> commentModel = [];
  bool isLoading = true;
  TextEditingController comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllComments();
  }

  void getAllComments() async {
    commentModel = await CommentFunction.getAllReelComment(widget.reelId) ?? [];

    setState(() {
      isLoading = false;
    });
  }

  void onPostComment() async {
    if (comment.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      String uid = await SharedPreferencesHelper.getString("uid");
      String username = await SharedPreferencesHelper.getString("username");
      String profileImage =
          await SharedPreferencesHelper.getString("profile_image");
      CommentsModel commentsModel = CommentsModel(
          id: generatedId(),
          uid: uid,
          username: username,
          profileImage: profileImage,
          comment: comment.text);

      await CommentFunction.postComment(widget.reelId, commentsModel);

      commentModel.add(commentsModel);

      commentModel.clear();

      comment.text = "";

      getAllComments();

      setState(() {
        isLoading = false;
      });
    } else {
      toast("Don't Leave Comment Field");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: isLoading
          ? LoadingScreen()
          : Column(
              children: [
                commentModel.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: commentModel.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(commentModel[index].username),
                              subtitle: Text(commentModel[index].comment),
                              leading: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreenUiUp(
                                            UserId: commentModel[index].uid),
                                      ));
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  backgroundImage: NetworkImage(
                                      commentModel[index].profileImage),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Center(
                        child: Text("No Comments Available"),
                      )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: comment,
                          decoration: InputDecoration(
                              hintText: "Comment",
                              border: OutlineInputBorder()),
                          scrollController: ScrollController(),
                          cursorColor: primaryColor,
                          //keyboardType: TextInputType.multiline,
                        ),
                      ),
                      IconButton(
                        onPressed: onPostComment,
                        icon: Icon(Icons.send_outlined),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
