import 'package:flutter/material.dart';
import 'package:sabanci_talks/firestore_classes/firestore_main/firestore.dart';
import 'package:sabanci_talks/firestore_classes/follower/follower.dart';
import 'package:sabanci_talks/widgets/person_header_widget.dart';

class Followers extends StatelessWidget {
  Followers({Key? key, required this.mylist}) : super(key: key);
  dynamic mylist;
  static const String routeName = '/followers';

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Followers'),
          ),
          body: SizedBox(
            width: double.infinity,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  PersonHeaderWidget(element: mylist[index]),
              separatorBuilder: (context, index) => const SizedBox(
                height: 4,
              ),
              itemCount: mylist != null ? mylist.length : 0,
            ),
          ));
    });
  }
}
