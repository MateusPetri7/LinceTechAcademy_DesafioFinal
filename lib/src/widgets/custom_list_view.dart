import 'package:flutter/material.dart';

class CustomListView<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final void Function(T) onEdit;
  final Future<void> Function(T) onDelete;
  final void Function(T) onTap;

  const CustomListView({
    Key? key,
    required this.items,
    required this.getTitle,
    required this.getSubtitle,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.isEmpty
          ? const Center(child: Text('No items found'))
          : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: ListTile(
              title: Text(getTitle(item)),
              subtitle: Text(getSubtitle(item)),
              onTap: () => onTap(item),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => onEdit(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onDelete(item),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
