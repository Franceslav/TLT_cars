import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/widgets/buttons/button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../res/styles.dart';
import '../widgets/buttons/button2.dart';

class CommentPage extends StatefulWidget {
  CommentPage({
    super.key,
    required this.setComment,
  });
  Function setComment;
  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var comment = TextEditingController();

  @override
  void initState() {
    comment = TextEditingController(
        text: context.read<RouteFromToCubit>().get().comment ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Container(
            alignment: Alignment.bottomLeft,
            color: Colors.white,
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, left: 10),
            child: InkWell(
              onTap: () {
                // widget.isFrom
                //     ? context.read<RouteFromToCubit>().setFrom(result[0])
                //     : context.read<RouteFromToCubit>().setTo(result[0]);
                // widget.setAddress();
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: comment,
                maxLines: 10,
                decoration: InputDecoration(
                  fillColor: whiteGrey,
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      width: 0.1,
                      color: black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      width: 0.4,
                      color: blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      width: 0.1,
                      color: black,
                    ),
                  ),
                  hintStyle: h13w400Black,
                  hintText: 'Комментарий водителю',
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                context.read<RouteFromToCubit>().setComment(
                      comment.text,
                    );
                widget.setComment(comment.text);
                Get.back();
              },
              child: Button2(
                  title: context.read<RouteFromToCubit>().get().comment != null
                      ? 'Редактировать '
                      : 'Добавить '),
            ),
          )
        ]),
      ),
    );
  }
}
