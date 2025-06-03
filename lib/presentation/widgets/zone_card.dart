import 'package:flutter/material.dart';
import 'package:greenhouse_app/domain/crop_zone.dart';

class ZoneCard extends StatelessWidget {
  final CropZone zone;
  final VoidCallback? onTap;

  const ZoneCard({super.key, required this.zone, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(zone.title),
              const SizedBox(height: 8),
              Text('Crops: ${zone.crop?.title ?? 'None'}'),
              const SizedBox(height: 8),
              Text('Area: ${zone.area} m²'),
              const SizedBox(height: 8),
              Text('cycle: ${zone.day.toStringAsFixed(2)} days'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onTap,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primaryContainer,
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    child: Text('Configure'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
