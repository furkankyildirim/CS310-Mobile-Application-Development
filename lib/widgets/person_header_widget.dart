import 'package:flutter/material.dart';
import 'package:sabanci_talks/firestore_classes/firestore_main/firestore.dart';
import 'package:sabanci_talks/firestore_classes/follower/follower.dart';
import 'package:sabanci_talks/firestore_classes/user/my_user.dart';
import 'package:sabanci_talks/util/colors.dart';

class PersonHeaderWidget extends StatefulWidget {
  PersonHeaderWidget({Key? key, required this.element}) : super(key: key);
  dynamic element;
  @override
  State<PersonHeaderWidget> createState() => _PersonHeaderWidgetState();
}

class _PersonHeaderWidgetState extends State<PersonHeaderWidget> {
  dynamic isFollowing = false;
  dynamic uid;
  dynamic user;
  Firestore f = Firestore();
  dynamic isWaiting = false;
  Future<void> userList() async {
    uid = await f.decideUser();
    user = await f.getUser(widget.element);
    //debugPrint("userrrr ${user.toString()}");
    isFollowing = await f.isFollowed(uid, widget.element);
  }

  changeFollowing() async {
    dynamic isPriv = await f.isPrivate(widget.element);
    if (isFollowing == true) {
      await f.unFollow(widget.element, uid);
      await f.deleteFollowing(uid, widget.element);
    } else {
      if (isPriv == true) {
        await f.addRequest(widget.element, uid);
        await f.addNotification(
            uid: widget.element,
            notification_type: "request",
            uid_sub: uid,
            isPost: false);
      } else {
        await f.addFollow(widget.element, uid);
        await f.addFollowing(uid, widget.element);
        await f.addNotification(
            uid: widget.element,
            notification_type: "follow",
            uid_sub: uid,
            isPost: false);
      }
    }
    setState(() {
      if (isFollowing == true) {
        //f.deleteFollowing(widget.element, uid);
        isFollowing = false;
      } else {
        if (isPriv == true) {
          isWaiting = true;
        } else {
          isFollowing == true;
        }
      }
    });
    userList();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint("helllooooo ${isFollowing != null ? isFollowing == true : -1}");
    return FutureBuilder(
        future: userList(),
        builder: (context, snapshot) {
          return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.network(
                  user != null
                      ? user[1].profilePicture
                      : "https://picsum.photos/600",
                ),
              ),
              title: Text(user != null ? user[1].fullName : ""),
              //subtitle: const Text('@Carlossainz55'),
              trailing: InkWell(
                onTap: () => changeFollowing(),
                child: Container(
                  width: 128,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isFollowing == true
                        ? AppColors.textColor
                        : isWaiting == true
                            ? AppColors.textColor
                            : Colors.transparent,
                    border: Border.all(
                      color: isFollowing == true
                          ? Colors.transparent
                          : isWaiting == true
                              ? Colors.transparent
                              : AppColors.darkGrey,
                      width: 1,
                    ),
                  ),
                  child: Text(
                      isFollowing == true
                          ? 'Following'
                          : isWaiting == true
                              ? "Request Sent"
                              : 'Follow',
                      style: TextStyle(
                          color: isFollowing == true
                              ? Colors.white
                              : isWaiting == true
                                  ? Colors.white
                                  : AppColors.textColor,
                          fontWeight: FontWeight.w500)),
                ),
              ));
        });
  }
}
