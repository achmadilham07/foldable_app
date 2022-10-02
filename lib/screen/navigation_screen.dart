import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/model/locations.dart';
import '../provider/hinge_notifier.dart';
import '../provider/location_notifier.dart';
import '../widget/google_maps_list_widget.dart';
import '../widget/google_maps_pin_widget.dart';

class NavigationScreen extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  NavigationScreen() : _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Office? office;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          child: viewListWidget(context),
        ),
        if (office != null)
          MaterialPage(
            child: viewMapsWidget(context),
          ),
      ],
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return didPop;
        }
        office = null;
        notifyListeners();

        return didPop;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }

  Widget viewListWidget(BuildContext context) {
    return context.watch<LocationNotifier>().isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMapsListWidget(
            onTap: (Office? value) {
              final hasHinge = context.read<HingeNotifier>().hasHinge;
              if (!hasHinge) {
                office = value;
                notifyListeners();
              }
            },
          );
  }

  Widget viewMapsWidget(BuildContext context) {
    return context.watch<LocationNotifier>().isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMapsPinWidget(
            googleOffices:
                context.read<LocationNotifier>().location?.offices ?? [],
            office: office,
          );
  }
}
