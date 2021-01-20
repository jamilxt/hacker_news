import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hacker_news/bloc/comments_bloc/comments_bloc.dart';
import 'package:hacker_news/bloc/comments_bloc/comments_event.dart';
import 'package:hacker_news/bloc/comments_bloc/comments_state.dart';
import 'package:hacker_news/model/comments.dart';
import 'package:hacker_news/model/story.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentPage extends StatefulWidget {
  static const String comPage = '/commentTestPage';

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  CommentsBloc commentsBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentsBloc = BlocProvider.of<CommentsBloc>(context);
    //commentsBloc.add(FetchCommentsEvent(Story));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment News"),
      ),
      body: Container(
        child: BlocListener<CommentsBloc, CommentsState>(
          listener: (context, state) {
            if (state is CommentsErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<CommentsBloc, CommentsState>(
            builder: (context, state) {
              if (state is CommentsInitialState) {
                print("initaial page ");
                return buildLoading();
              } else if (state is CommentsLoadingState) {
                print("initaial page loading");
                return buildLoading();
              } else if (state is CommentsLoadedState) {
                print("page loaded");
                return buildArticleList(state.comments);
              } else if (state is CommentsErrorState) {
                print("error");
                return buildErrorUi(state.message);
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildArticleList(List<Comment> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: /*ListTile(
              title: Text(articles[pos].text ?? ""),
              subtitle: Text(articles[pos].commentId ?? ""),
            ),*/
            ListTile(
                leading: Container(
                    alignment: Alignment.center,
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text("${1 + pos}",
                        style: TextStyle(fontSize: 22, color: Colors.white))),
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    articles[pos].text ?? "",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                )),
            onTap: () {
              //_launchUrl(articles[pos].url);
            },
          ),
        );
      },
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
