import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final DateTime startDate;
  const MyHeatMap({super.key, required this.startDate, this.datasets});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets ?? {},
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.inversePrimary,
      showColorTip: false,
      showText: true,
      borderRadius: 5,
      scrollable: true,
      size: 40,
      colorsets: {
        1: Colors.green.shade200,
        2: Colors.green.shade400,
        3: Colors.green.shade600,
        4: Colors.green.shade800,
        5: Colors.green.shade900,
      },
    );
  }
}
