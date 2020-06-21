import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class DynamicLinkService {
  List<String> friendUID = [];
  bool showFriend = false;
  Future<bool> handleDynamicLinks() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    friendUID = await SharedPrefUtils.readPrefStrList('friendUID') ?? [];
    String sign = await SharedPrefUtils.readPrefStr('isSignUpDone') ?? 'no';
    bool isSignUp = sign == 'yes' ? true : false;

    if(isSignUp){
      //AFTER CLOSE
      await _handleLink(data);

      //AFTER SUSPENSION
      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (dynamicLinkData) async {
          return await _handleLink(dynamicLinkData);
        },
        onError: (e) async {print('Error occured ${e.message}');},
      );

      return showFriend;
    }
    return false;
  }

  _handleLink(PendingDynamicLinkData data) async{
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print(deepLink);
      var link = deepLink.pathSegments;
      if(friendUID == null){
        friendUID.add(link[0]);
        print(friendUID);
      }
      else if(friendUID.contains(link[0])){
        return;
      }
      else {
        friendUID.add(link[0]);
        print(friendUID);
        await SharedPrefUtils.saveStrList('friendUID', friendUID);
        //flags to push the screen
        showFriend = true;
        //flag to use cloud
        await SharedPrefUtils.saveStr('refresh', 'yes');
      }
    }
  }
}
