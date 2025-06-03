import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/domain/greenhouse.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';
import 'package:greenhouse_app/presentation/widgets/zone_card.dart';
import 'package:greenhouse_app/presentation/zone_configuration_screen.dart';

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

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
              if (state is GreenhouseLoadedState)
                IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () {
                    context.read<GreenhouseBloc>().add(const LoadGreenhousesEvent());
                  },
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (state is GreenhousesLoadedState) {
                _showCreateGreenhouseDialog(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: BlocProvider.of<GreenhouseBloc>(context),
                      child: ZoneConfigurationScreen(
                        zoneId: null,
                      ),
                    ),
                  ),
                );
              }
            },
            child: Icon(
              state is GreenhousesLoadedState ? Icons.add_home : Icons.add,
            ),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: switch (state) {
              GreenhouseInitialState() => const _WelcomeView(),
              GreenhouseLoadingState() => const _LoadingView(),
              GreenhouseLoadedState(greenhouse: final greenhouse) =>
                _ZonesListView(greenhouse: greenhouse),
              GreenhousesLoadedState(greenhouses: final greenhouses) =>
                _GreenhousesListView(greenhouses: greenhouses),
              GreenhouseErrorState(message: final message) =>
                _ErrorView(message: message),
              GreenhouseState() => throw UnimplementedError(),
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
  final Greenhouse greenhouse;
  const _ZonesListView({required this.greenhouse});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: greenhouse.zones
          .map(
            (zone) => ZoneCard(
              zone: zone,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: BlocProvider.of<GreenhouseBloc>(context),
                    child: ZoneConfigurationScreen(
                      zoneId: zone.id,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _GreenhousesListView extends StatelessWidget {
  final List<Greenhouse> greenhouses;
  const _GreenhousesListView({required this.greenhouses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: greenhouses.length,
      itemBuilder: (context, index) {
        final greenhouse = greenhouses[index];
        return Card(
          child: ListTile(
            title: Text(greenhouse.title),
            subtitle: Text('${greenhouse.zones.length} zones'),
            onTap: () {
              context.read<GreenhouseBloc>().add(
                LoadGreenhouseEvent(greenhouseId: greenhouse.id),
              );
            },
          ),
        );
      },
    );
  }
}
