import 'package:flutter/material.dart';
import 'package:sabanci_talks/widgets/person_header_widget.dart';

class Following extends StatelessWidget {
  const Following({Key? key}) : super(key: key);

  static const String routeName = '/followers';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Following'),
        ),
        body: _body());
  }

  SizedBox _body() => SizedBox(
        width: double.infinity,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          shrinkWrap: true,
          itemBuilder: (context, index) => const PersonHeaderWidget(),
          separatorBuilder: (context, index) => const SizedBox(
            height: 4,
          ),
          itemCount: 12,
        ),
      );
}
