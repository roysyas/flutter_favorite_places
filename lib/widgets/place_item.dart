import 'package:flutter/material.dart';
import 'package:flutter_favorite_places/models/place.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({
    super.key,
    required this.placeModel,
    required this.onSelect,
  });

  final PlaceModel placeModel;
  final void Function(PlaceModel placeModel) onSelect;

  @override
  Widget build(BuildContext context) {
    print(placeModel.image);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          onSelect(placeModel);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: FileImage(placeModel.image),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placeModel.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    placeModel.placeLocation.address,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
