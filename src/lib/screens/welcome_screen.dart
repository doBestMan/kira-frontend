import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kira_auth/widgets/appbar_wrapper.dart';
import 'package:kira_auth/widgets/custom_button.dart';
import 'package:kira_auth/utils/colors.dart';
import 'package:kira_auth/utils/strings.dart';
import 'package:kira_auth/utils/styles.dart';
import 'package:kira_auth/utils/cache.dart';
import 'package:kira_auth/services/status_service.dart';
import 'package:kira_auth/models/node_info_model.dart';
import 'package:kira_auth/models/sync_info_model.dart';
import 'package:kira_auth/bloc/account_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  NodeInfoModel nodeInfo;
  SyncInfoModel syncInfo;
  String networkId;
  bool isNetworkHealthy;
  List<String> networkIds = [];

  void getNodeStatus() async {
    StatusService statusService = StatusService();
    await statusService.getNodeStatus();

    nodeInfo = statusService.nodeInfo;
    syncInfo = statusService.syncInfo;

    DateTime latestBlockTime = DateTime.parse(syncInfo.latestBlockTime);

    if (mounted) {
      setState(() {
        networkIds.add(nodeInfo.network);
        networkId = nodeInfo.network;

        isNetworkHealthy =
            DateTime.now().difference(latestBlockTime).inMinutes > 1
                ? false
                : true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isNetworkHealthy = true;
    getNodeStatus();
  }

  @override
  Widget build(BuildContext context) {
    checkPasswordExpired().then((success) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return Scaffold(
        body: BlocConsumer<AccountBloc, AccountState>(
            listener: (context, state) {},
            builder: (context, state) {
              return AppbarWrapper(
                  childWidget: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    addHeaderText(),
                    // addDescription(),
                    addNetworkId(context),
                    addTokenBalancesButton(),
                    addSettingsButton(),
                    addLogoutButton(),
                  ],
                ),
              ));
            }));
  }

  Widget addHeaderText() {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Text(
          "Welcome to Kira Core",
          textAlign: TextAlign.center,
          style: TextStyle(color: KiraColors.kPrimaryColor, fontSize: 30),
        ));
  }

  Widget addDescription() {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(children: <Widget>[
          Expanded(
              child: Text(
            Strings.networkDescription,
            textAlign: TextAlign.center,
            style: TextStyle(color: KiraColors.kYellowColor, fontSize: 18),
          ))
        ]));
  }

  Widget addNetworkId(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Strings.networkId,
                style: TextStyle(color: KiraColors.kPurpleColor, fontSize: 20)),
            Container(
                width: MediaQuery.of(context).size.width *
                    (smallScreen(context) ? 0.62 : 0.32),
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: KiraColors.kPrimaryColor),
                    color: KiraColors.kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(25)),
                // dropdown below..
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                        value: networkId,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 32,
                        underline: SizedBox(),
                        onChanged: (String netId) {
                          setState(() {
                            networkId = netId;
                          });
                        },
                        items: networkIds
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(
                                    color: KiraColors.kPurpleColor,
                                    fontSize: 18)),
                          );
                        }).toList()),
                  ),
                )),
            Text(isNetworkHealthy ? "Status: healthy" : "Status: unhealthy",
                style: TextStyle(
                    color: isNetworkHealthy == true
                        ? KiraColors.green2
                        : KiraColors.kYellowColor,
                    fontSize: 20)),
            SizedBox(height: 20),
          ],
        ));
  }

  Widget addLogoutButton() {
    return Container(
        width: MediaQuery.of(context).size.width *
            (smallScreen(context) ? 0.62 : 0.25),
        margin: EdgeInsets.only(bottom: 30),
        child: CustomButton(
          key: Key('log_out'),
          text: Strings.logout,
          height: 44.0,
          onPressed: () {
            removeCachedPassword();
            Navigator.pushReplacementNamed(context, '/');
          },
          backgroundColor: KiraColors.kPrimaryColor,
        ));
  }

  Widget addTokenBalancesButton() {
    return Container(
        width: MediaQuery.of(context).size.width *
            (smallScreen(context) ? 0.62 : 0.25),
        margin: EdgeInsets.only(bottom: 30),
        child: CustomButton(
          key: Key('balances'),
          text: Strings.tokenBalances,
          height: 44.0,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/tokens');
          },
          backgroundColor: KiraColors.kPrimaryColor,
        ));
  }

  Widget addSettingsButton() {
    return Container(
        width: MediaQuery.of(context).size.width *
            (smallScreen(context) ? 0.62 : 0.25),
        margin: EdgeInsets.only(bottom: 30),
        child: CustomButton(
          key: Key('settings'),
          text: Strings.settings,
          height: 44.0,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/settings');
          },
          backgroundColor: KiraColors.kPrimaryColor,
        ));
  }
}
