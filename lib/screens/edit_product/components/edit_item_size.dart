import 'package:flutter/material.dart';
import 'package:virtual_store/common/custom_icon_button.dart';
import 'package:virtual_store/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize(
      {Key key, this.size, this.onRemove, this.onMoveDown, this.onMoveUp})
      : super(key: key);

  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: InputDecoration(
              labelText: 'Titulo',
              isDense: true,
            ),
            validator: (name) {
              if (name.isEmpty) return 'Invalido';
              return null;
            },
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration: InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            validator: (stock) {
              if (int.tryParse(stock) == null) return 'Invalido';
              return null;
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            decoration: InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$',
            ),
            validator: (price) {
              if (num.tryParse(price) == null) return 'Invalido';
              return null;
            },
            onChanged: (price) => size.price = num.tryParse(price),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.red,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}
