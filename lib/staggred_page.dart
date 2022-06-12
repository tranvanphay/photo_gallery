import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_gallery/common.dart';
import 'package:collection/collection.dart';
import 'package:photo_gallery/db/database.dart';
import 'package:photo_gallery/model/item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StaggeredPage extends StatelessWidget {
  final String title;
  const StaggeredPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          FutureBuilder<List<Item>>(
              future: _getPhoto(),
              builder: (context, photoSnap) {
                if (photoSnap.hasData) {
                  return StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: [
                      ...photoSnap.data!.mapIndexed((index, item) {
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: CachedNetworkImage(
                            imageUrl: item.thumnail ?? '',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        );
                      }),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      ),
    );
  }

  Future<List<Item>> _getPhoto() async {
    return await SQLiteDbProvider.instance.getPhotoByDate(title);
  }
}

class GridTile {
  const GridTile(this.crossAxisCount, this.mainAxisCount);
  final int crossAxisCount;
  final int mainAxisCount;
}
