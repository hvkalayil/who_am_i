import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/screens/GHomeScreen/landing_screen.dart';
import 'package:whoami/screens/HSettingsScreen/SavedCards/saved_cards.dart';
import 'package:whoami/service/dynamic_link_service.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  final String id;

  LifeCycleManager({Key key, this.child,this.id}) : super(key: key);

  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {

  DynamicLinkService _linkService = DynamicLinkService();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.resumed){
      String mainCheck = await SharedPrefUtils.readPrefStr('isSignUpDone') ?? 'no';
      bool mainBool = mainCheck == 'yes' ? true : false;
      if(mainBool){
        bool tempshow = await _linkService.handleDynamicLinks();
        String ref = await SharedPrefUtils.readPrefStr('refresh') ?? 'no';
        bool show = ref == 'yes' ? true : false;
        if(show) {
            Navigator.pushNamed(context, SavedCards.id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
