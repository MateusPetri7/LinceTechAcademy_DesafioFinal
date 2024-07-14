import 'package:flutter/material.dart';

class CustomListView<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) getTitle;
  final String Function(T) getSubtitle;
  final void Function(T) onEdit;
  final void Function(T) onDelete;

  const CustomListView({
    Key? key,
    required this.items,
    required this.getTitle,
    required this.getSubtitle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.isEmpty
          ? Center(child: Text('No items found'))
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => onEdit(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Center(
                              child: Text('Confirmation'),
                            ),
                            content: const Text('Are you sure you want to delete this item?'),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmDelete == true) {
                        onDelete(item);
                      }
                    },
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
