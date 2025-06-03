import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';
import 'package:greenhouse_app/presentation/widgets/zone_card.dart';
import 'package:greenhouse_app/presentation/zone_configuration_screen.dart';

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = GreenhouseBloc(const GreenhouseInitialState())
      ..add(const LoadGreenhouseEvent());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text('Greenhouse')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ZoneConfigurationScreen(
                    zoneId: null, // null for new zone
                    bloc: bloc,
                  ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new zone feature coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<GreenhouseBloc, GreenhouseState>(
          bloc: bloc,
          builder: (context, state) {
            return ListView(
              children: switch (state) {
                GreenhouseInitialState() => [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      const Center(child: Text('Welcome to the Greenhouse!')),
                    ],
                  ),
                ],
                GreenhouseLoadingState() => [
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ],
                GreenhouseLoadedState(greenhouse: final greenhouse) =>
                  greenhouse.zones
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
                GreenhouseErrorState(message: final message) => [
                  Center(child: Text('Error: $message')),
                ],
                GreenhouseState() => throw UnimplementedError(),
              },
            );
          },
        ),
      ),
    );
  }
}
