import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/providers/place_provider.dart';
import 'package:flutter_favorite_places/screens/add_item.dart';
import 'package:flutter_favorite_places/widgets/place_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourPlaces extends ConsumerStatefulWidget {
  const YourPlaces({super.key});

  @override
  ConsumerState<YourPlaces> createState() {
    return _YourPlacesState();
  }
}

class _YourPlacesState extends ConsumerState<YourPlaces> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placeProvider.notifier).loadPlaces();
  }

  void _addItem(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddItem(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              _addItem(context);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : PlaceList(places: places),
      ),
    );
  }
}
