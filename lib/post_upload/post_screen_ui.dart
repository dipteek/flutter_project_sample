import 'package:flutter/material.dart';
import 'package:reel_app/loading_screen/loading_screen.dart';
import 'package:reel_app/model_classes/post_model.dart';
import 'package:reel_app/post_upload/post_upload_function.dart';

class PostScreenUI extends StatefulWidget {
  const PostScreenUI({super.key});

  @override
  State<PostScreenUI> createState() => _PostScreenUIState();
}

class _PostScreenUIState extends State<PostScreenUI> {
  List<PostModel> postsModel = [];
  bool isLoading = true;
  bool isImgLoading = true;
  String profileImgUrl = "";

  @override
  void initState() {
    super.initState();
    getStroyData();
  }

  void getStroyData() async {
    postsModel = await PostUploadFunction.getPosts() ?? [];

    setState(() {
      isLoading = false;
    });
  }

  void getProfile(String uid) async {
    profileImgUrl = await PostUploadFunction.getPostedUserProfileImg(uid);
    setState(() {
      isImgLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: postsModel.length,
        itemBuilder: (context, index) {
          getProfile(postsModel[index].uid);
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: isImgLoading
                            ? CircularProgressIndicator()
                            : CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                backgroundImage: NetworkImage(profileImgUrl),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(postsModel[index].username),
                      ),
                    ],
                  ),
                  postsModel[index].imgLink.isNotEmpty
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          child: Image.network(
                            postsModel[index].imgLink,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            /*frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              return Padding(
                                padding: const EdgeInsets.all(0),
                                child: child,
                              );
                            },*/
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width,
                          ),
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: postsModel[index].description.isNotEmpty
                        ? Text(
                            postsModel[index].description,
                            maxLines:
                                postsModel[index].imgLink.isNotEmpty ? 2 : 6,
                            style: TextStyle(),
                          )
                        : SizedBox(),
                  ),
                  Divider()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
