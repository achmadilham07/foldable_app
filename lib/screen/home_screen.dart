import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:foldable_app/utils/extension/media_query_extension.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../data/model/locations.dart' as location;
import '../provider/hinge_notifier.dart';
import '../provider/location_notifier.dart';
import '../widget/google_maps_list_widget.dart';
import '../widget/google_maps_pin_widget.dart';
import 'navigation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<GoogleMapsPinWidgetState> googleMapsWidgetState =
      GlobalKey<GoogleMapsPinWidgetState>();
  location.Office? office;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      context.read<LocationNotifier>().getLocation();

      final hasHinge = MediaQuery.of(context).hasHinge;
      context.read<HingeNotifier>().hasHinge = hasHinge;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final hasHinge = MediaQuery.of(context).hasHinge;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HingeNotifier>().hasHinge = hasHinge;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasHinge = MediaQuery.of(context).hasHinge;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Office"),
      ),
      body: context.watch<HingeNotifier>().hasHinge || hasHinge
          ? viewWithTwoPane()
          : Router(
              routerDelegate: NavigationScreen(),
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
    );
  }

  Widget viewListWidget() {
    return context.watch<LocationNotifier>().isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMapsListWidget(
            onTap: (location.Office? value) {
              final hasHinge = context.read<HingeNotifier>().hasHinge;
              if (hasHinge) {
                googleMapsWidgetState.currentState?.googleMapController
                    .animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(value!.lat, value.lng),
                    2,
                  ),
                );
              }
            },
          );
  }

  Widget viewMapsWidget() {
    return context.watch<LocationNotifier>().isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMapsPinWidget(
            key: googleMapsWidgetState,
            googleOffices:
                context.read<LocationNotifier>().location?.offices ?? [],
            office: office,
          );
  }

  Widget viewWithTwoPane() {
    return TwoPane(
      startPane: viewListWidget(),
      endPane: viewMapsWidget(),
      panePriority: MediaQuery.of(context).hasHinge
          ? TwoPanePriority.both
          : TwoPanePriority.start,
    );
  }
}
