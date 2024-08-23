import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../utils/strings.dart';
import '../model/EuropeanCountryResponse.dart';
import '../viewmodel/ApiViewModel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Handle no internet connectivity
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please check your internet connection and try again."),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Proceed with data fetching
      final apiViewModel = Provider.of<ApiViewModel>(context, listen: false);
      await apiViewModel.fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(appTitle),
      ),
      body: Consumer<ApiViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.data.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return ListView.builder(
            itemCount: viewModel.data.length,
            itemBuilder: (context, index) {
              final item = viewModel.data[index];
              return ListTile(
                title: Text(item.commonName),
                subtitle: Text(
                  'Capital: ${item.capital.isNotEmpty ? item.capital.join(', ') : 'N/A'}',
                ),
                leading: Image.network(
                  item.flagPng,
                  width: 50,
                  height: 30,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
                onTap: () {
                  showCountryInfoDialog(context, item);
                },
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.orangeAccent,
        elevation: 20.0,
        child: const Icon(Icons.sort_by_alpha),
        children: [
          SpeedDialChild(
            child: const Icon(Icons.sort_by_alpha),
            label: 'Sort By Name',
            onTap: () =>{
              context.read<ApiViewModel>().sortCountriesAlphabetically(),
              showToast("Countries sorted alphabetically"),
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.location_city),
            label: 'Sort By Capital',
            onTap: () =>
            {
              context.read<ApiViewModel>().sortCountriesByCapital(),
              showToast("Countries sorted by capital"),
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.people),
            label: 'Sort By Population',
            onTap: () =>
            {
              context.read<ApiViewModel>().sortCountriesByPopulation(),
              showToast("Countries sorted by population "),
            }
          ),
        ],
      ),
    );
  }

  void showCountryInfoDialog(BuildContext context, EuropeanCountryResponse item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.commonName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                item.flagPng,
                width: 100,
                height: 60,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text('Capital: ${item.capital.isNotEmpty ? item.capital.join(', ') : 'N/A'}'),
              const SizedBox(height: 8),
              Text('Official Name: ${item.officialName}'),
              const SizedBox(height: 8),
              Text("${item.flagAlt}"),
              const SizedBox(height: 8),
              Text('Native names: ${item.nativeNames}'),
              const SizedBox(height: 8),
              Text('Population: ${item.population.toString()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showToast(String message) async {
    await Fluttertoast.cancel();
    Fluttertoast.showToast(msg: message, fontSize: 18);
  }
}
