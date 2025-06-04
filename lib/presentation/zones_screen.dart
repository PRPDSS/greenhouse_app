import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/domain/crop_zone.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';
import 'package:greenhouse_app/presentation/widgets/zone_card.dart';
import 'package:greenhouse_app/presentation/zone_configuration_screen.dart';

class ZonesScreen extends StatelessWidget {
  final int greenhouseId;
  const ZonesScreen({super.key, required this.greenhouseId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GreenhouseBloc, GreenhouseState>(
      bloc: context.read<GreenhouseBloc>(),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text('Greenhouse'),
            actions: [
              if (state is GreenhousesLoadedState)
                IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () {
                    context.read<GreenhouseBloc>().add(
                      const LoadGreenhousesEvent(),
                    );
                  },
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider.value(
                        value: BlocProvider.of<GreenhouseBloc>(context),
                        child: const ZoneConfigurationScreen(
                          zoneId: null,
                          greenhouseId: null,
                        ),
                      ),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: switch (state) {
              GreenhouseInitialState() => const _WelcomeView(),
              GreenhouseLoadingState() => const _LoadingView(),
              GreenhousesLoadedState(greenhouses: final greenhouses) =>
                _ZonesListView(
                  zones:
                      greenhouses.firstWhere((g) => g.id == greenhouseId).zones,
                  greenhouseId: greenhouseId,
                ),
              GreenhouseErrorState(message: final message) => _ErrorView(
                message: message,
              ),
              GreenhouseState() => const _LoadingView(),
            },
          ),
        );
      },
    );
  }

  void _showCreateGreenhouseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Create New Greenhouse'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Greenhouse Name',
              hintText: 'Enter greenhouse name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<GreenhouseBloc>().add(
                    CreateGreenhouseEvent(title: controller.text),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 16),
        Center(child: Text('Welcome to the Greenhouse!')),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 16),
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Error: $message'));
  }
}

class _ZonesListView extends StatelessWidget {
  final List<CropZone> zones;
  final int greenhouseId;

  const _ZonesListView({required this.zones, required this.greenhouseId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: zones.length,
      itemBuilder: (context, index) {
        final zone = zones[index];
        return ZoneCard(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider.value(
                      value: BlocProvider.of<GreenhouseBloc>(context),
                      child: ZoneConfigurationScreen(
                        zoneId: null,
                        greenhouseId: greenhouseId,
                      ),
                    ),
              ),
            );
          },
          zone: zone,
        );
      },
    );
  }
}
