import 'package:flutter/material.dart';
import 'package:sqflite_crud/sqflite/sql_helper.dart';

class SQFLITE_View extends StatefulWidget {
  const SQFLITE_View({super.key});

  @override
  State<SQFLITE_View> createState() => _SQFLITE_ViewState();
}

class _SQFLITE_ViewState extends State<SQFLITE_View> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  void refresh() async {
    final items = await SQLHelper.getItems();
    setState(() {
      data = items;
      isLoading = false;
    });
  }

  Future<void> addItem() async {
    SQLHelper.createItem(title.text, description.text);
    refresh();
    print("... number of items ${data.length}");
  }

  Future<void> updateItem(int id) async {
    await SQLHelper.updateItem(id, title.text, description.text);
    refresh();
  }

  void deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Deleted")));
    refresh();
  }

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  void showBottom(int? id) async {
    if (id != null) {
      final existingData = data.firstWhere((element) => element[id] == id);
      title.text = existingData['title'];
      description.text = existingData['description'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(hintText: 'title'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: description,
              decoration: InputDecoration(hintText: 'description'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await addItem();
                  }
                  if (id != null) {
                    await updateItem(id);
                  }

                  title.text = ' ';
                  description.text = ' ';
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create' : 'Update'))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    refresh();
    super.initState();
    print("....number of data items ${data.length}");
  }

  @override
  void dispose() async {
    // await SQLHelper.deleteAll();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQL"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.blue.withOpacity(0.5),
            margin: EdgeInsets.all(12),
            child: ListTile(
              title: Text(
                data[index]['title'] ?? "Null",
              ),  
              subtitle: Text(data[index]['description'] ?? "NUll"),
              trailing: SizedBox(
                width: 110,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          return showBottom(data[index]['id']);
                        },
                        icon: Icon(Icons.edit)),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: ()=> deleteItem(data[index]['id']),
                        icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          return showBottom(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
