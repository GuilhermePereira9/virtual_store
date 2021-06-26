import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:virtual_store/models/product_manager.dart';
import 'package:virtual_store/models/section_item.dart';
import 'package:provider/provider.dart';

class ItemTile extends StatelessWidget {
  const ItemTile(this.item);

  final SectionItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProductByID(item.product);
          if (product != null) {
            Navigator.of(context).pushNamed('/product', arguments: product);
          }
        }
      },
      child: AspectRatio(
          aspectRatio: 1,
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: item.image,
            fit: BoxFit.cover,
          )),
    );
  }
}
