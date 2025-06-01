import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/zones_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/zones_event.dart';
import 'package:greenhouse_app/presentation/bloc/zones_state.dart';
import 'package:greenhouse_app/presentation/widgets/zone_card.dart';
import 'package:greenhouse_app/presentation/zone_configuration_screen.dart';

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = ZonesBloc(const ZonesInitialState())
      ..add(const LoadZonesEvent());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text('Greenhouse')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle adding a new zone
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new zone feature coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<ZonesBloc, ZonesState>(
          bloc: bloc,
          builder: (context, state) {
            return ListView(
              children: switch (state) {
                ZonesInitialState() => [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      const Center(child: Text('Welcome to the Greenhouse!')),
                    ],
                  ),
                ],
                ZonesLoadingState() => [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ],
                ZonesLoadedState(zones: final zones) =>
                  zones
                      .map(
                        (zone) => ZoneCard(
                          zone: zone,
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ZoneConfigurationScreen(
                                        zoneId: zone.id,
                                        bloc: bloc,
                                      ),
                                ),
                              ),
                        ),
                      )
                      .toList(),
                ZonesErrorState(message: final message) => [
                  Center(child: Text('Error: $message')),
                ],
                ZonesState() => throw UnimplementedError(),
              },
            );
          },
        ),
      ),
    );
  }
}
