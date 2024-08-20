import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/models/place_location.dart';
import 'package:flutter_favorite_places/providers/place_provider.dart';
import 'package:flutter_favorite_places/widgets/image_input.dart';
import 'package:flutter_favorite_places/widgets/location_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItem extends ConsumerStatefulWidget {
  const AddItem({super.key});

  @override
  ConsumerState<AddItem> createState() {
    return _AddItemState();
  }
}

class _AddItemState extends ConsumerState<AddItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _saveItem() {
    if (_formKey.currentState!.validate() ||
        _selectedImage != null ||
        _selectedLocation != null) {
      _formKey.currentState!.save();
      ref
          .read(placeProvider.notifier)
          .setPlace(_enteredTitle, _selectedImage!, _selectedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add places'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1) {
                    return 'must be between 1 to 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredTitle = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ImageInput(
                onPick: (image) {
                  _selectedImage = image;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              LocationInput(
                onSelectLocation: (location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
