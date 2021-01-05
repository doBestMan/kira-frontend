import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:kira_auth/widgets/web_scrollbar.dart';
import 'package:kira_auth/widgets/hamburger_drawer.dart';
import 'package:kira_auth/widgets/top_bar_contents.dart';
import 'package:kira_auth/widgets/floating_quick_access_bar.dart';
import 'package:kira_auth/utils/responsive.dart';
import 'package:kira_auth/utils/strings.dart';
import 'package:kira_auth/utils/colors.dart';
import 'package:kira_auth/services/status_service.dart';
import 'package:kira_auth/utils/cache.dart';

class HeaderWrapper extends StatefulWidget {
  final Widget childWidget;

  const HeaderWrapper({Key key, this.childWidget}) : super(key: key);

  @override
  _HeaderWrapperState createState() => _HeaderWrapperState();
}

class _HeaderWrapperState extends State<HeaderWrapper> {
  StatusService statusService = StatusService();
  ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  double _opacity = 0;
  bool _isNetworkHealthy;
  bool _loggedIn;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  void getNodeStatus() async {
    await statusService.getNodeStatus();

    DateTime latestBlockTime = DateTime.parse(statusService.syncInfo.latestBlockTime);

    if (mounted) {
      setState(() {
        _isNetworkHealthy = DateTime.now().difference(latestBlockTime).inMinutes > 1 ? false : true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    this._isNetworkHealthy = false;
    _scrollController.addListener(_scrollListener);

    getNodeStatus();

    checkPasswordExists().then((success) {
      setState(() {
        _loggedIn = success;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.35 ? _scrollPosition / (screenSize.height * 0.40) : 0.9;

    _opacity = _opacity > 0.9 ? 0.9 : _opacity;
    _opacity = _loggedIn == true ? _opacity : 0.9;
    var networkStatusColor = _isNetworkHealthy == true ? KiraColors.green3 : KiraColors.orange3;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: HamburgerDrawer(),
      body: WebScrollbar(
        color: KiraColors.kYellowColor,
        backgroundColor: Colors.purple.withOpacity(0.3),
        width: 12,
        heightFraction: 0.3,
        controller: _scrollController,
        isAlwaysShown: false,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Strings.backgroundImage),
                fit: BoxFit.fill,
              ),
            ),
            alignment: AlignmentDirectional.center,
            child: SingleChildScrollView(
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    ResponsiveWidget.isSmallScreen(context)
                        ? AppBar(
                            toolbarHeight: 100,
                            backgroundColor: KiraColors.kBackgroundColor.withOpacity(0),
                            elevation: 0,
                            centerTitle: true,
                            actions: [
                              InkWell(
                                onTap: _isNetworkHealthy == null ? () {} : null,
                                child: Row(
                                  children: [
                                    Text(
                                      "Network Status ",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5), fontSize: 15, letterSpacing: 1),
                                    ),
                                    Container(
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                            color: networkStatusColor.withOpacity(0.5),
                                            width: 2,
                                          ),
                                        ),
                                        child: InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.circle,
                                              size: 12.0,
                                              color: networkStatusColor,
                                            ),
                                          ),
                                        )),
                                    SizedBox(width: 25)
                                  ],
                                ),
                              ),
                            ],
                            title: Row(
                              children: [
                                InkWell(
                                    child: Image(
                                  image: AssetImage(Strings.logoImage),
                                  width: 80,
                                  height: 80,
                                )),
                              ],
                            ),
                          )
                        : PreferredSize(
                            preferredSize: Size(screenSize.width, 1000),
                            child: TopBarContents(_opacity, _loggedIn, _isNetworkHealthy),
                          ),
                    SizedBox(height: 20),
                    widget.childWidget,
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        color: Color(0x00000000),
                        child: Padding(
                            padding: EdgeInsets.all(0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                    child: Image(
                                  image: AssetImage(Strings.grayLogoImage),
                                  width: 140,
                                  height: 140,
                                )),
                                Text(
                                  Strings.copyRight,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                                )
                              ],
                            ))),
                  ],
                ))),
      ),
    );
  }
}
