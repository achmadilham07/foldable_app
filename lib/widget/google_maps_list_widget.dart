import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/model/locations.dart';
import '../provider/location_notifier.dart';

class GoogleMapsListWidget extends StatelessWidget {
  final Function(Office? office) onTap;
  const GoogleMapsListWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final offices = context.read<LocationNotifier>().location?.offices;
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: offices?.length ?? 0,
      itemBuilder: (context, index) {
        final office = offices?[index];
        return ListTile(
          title: Text(office?.name ?? ""),
          subtitle: Text(
            office?.address ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            onTap(office);
          },
        );
      },
    );
  }
}
