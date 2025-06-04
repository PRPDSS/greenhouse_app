import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenhouse_app/domain/greenhouse.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_bloc.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_event.dart';
import 'package:greenhouse_app/presentation/bloc/greenhouse_state.dart';
import 'package:greenhouse_app/presentation/widgets/zone_card.dart';
import 'package:greenhouse_app/presentation/zone_configuration_screen.dart';
import 'package:greenhouse_app/presentation/zones_screen.dart';

class GreenhousesScreen extends StatelessWidget {
  const GreenhousesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GreenhouseBloc>(context);
    return BlocBuilder<GreenhouseBloc, GreenhouseState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(title: const Text('Greenhouses')),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showCreateGreenhouseDialog(context);
            },
            child: const Icon(Icons.add_home_outlined),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: switch (state) {
              GreenhouseInitialState() => const _WelcomeView(),
              GreenhouseLoadingState() => const _LoadingView(),
              GreenhousesLoadedState(greenhouses: final greenhouses) =>
                _GreenhousesListView(greenhouses: greenhouses),
              GreenhouseErrorState(message: final message) => _ErrorView(
                message: message,
              ),

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

class _GreenhousesListView extends StatelessWidget {
  final List<Greenhouse> greenhouses;
  const _GreenhousesListView({required this.greenhouses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: greenhouses.length,
      itemBuilder: (context, index) {
        final greenhouse = greenhouses[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ZonesScreen(greenhouseId: greenhouse.id)),
            );
          },
          child: Card(
            // elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ListTile(
                  title: Text(greenhouse.title),
                  subtitle: Text('${greenhouse.zones.length} zones'),
                ),
                if (greenhouse.zones.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: greenhouse.zones.length,
                      itemBuilder: (context, zoneIndex) {
                        final zone = greenhouse.zones[zoneIndex];
                        return ZoneCard(
                          zone: zone,
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BlocProvider.value(
                                        value: BlocProvider.of<GreenhouseBloc>(
                                          context,
                                        ),
                                        child: ZoneConfigurationScreen(
                                          zoneId: zone.id,
                                          greenhouseId: greenhouse.id,
                                        ),
                                      ),
                                ),
                              ),
                        );
                      },
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider.value(
                                value: BlocProvider.of<GreenhouseBloc>(context),
                                child: ZoneConfigurationScreen(
                                  zoneId: null,
                                  greenhouseId: greenhouse.id,
                                ),
                              ),
                        ),
                      );
                    },
                    child: const Text('Add Zone'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
