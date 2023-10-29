import 'package:flutter/material.dart';
import 'package:mhike_flutter/sql_helper.dart';
import 'hike.dart';
import 'observations_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Hike> hikes = [];
  bool parkingAvailable = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadHikes();
  }

  void _loadHikes() async {
    final data = await DBHelper.getData('hikes');
    setState(() {
      hikes.clear();
      hikes.addAll(data.map((item) => Hike.fromMap(item)));
        });
  }

  Future<void> _showEditHikeDialog(Hike hike) async {
    // Create controllers for the fields you want to edit
    final TextEditingController nameController = TextEditingController(text: hike.name);
    final TextEditingController locationController = TextEditingController(text: hike.location);
    final TextEditingController lengthController = TextEditingController(text: hike.length);
    final TextEditingController difficultyController = TextEditingController(text: hike.difficulty);
    final TextEditingController descriptionController = TextEditingController(text: hike.description);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Edit Hike"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name of Hike'),
                  ),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  // ... Add fields for other hike details (date, length, difficulty, description)
                  Row(
                    children: <Widget>[
                      const Text("Date of the Hike:"),
                      TextButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: lengthController,
                    decoration: const InputDecoration(labelText: 'Length of Hike'),
                  ),
                  TextField(
                    controller: difficultyController,
                    decoration:
                    const InputDecoration(labelText: 'Level of Difficulty'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),

                  Row(
                    children: <Widget>[
                      const Text("Parking Available:"),
                      Switch(
                        value: parkingAvailable,
                        onChanged: (value) {
                          setState(() {
                            parkingAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Save"),
                onPressed: () async {
                  // Update the hike data
                  final updatedHike = Hike(
                    id: hike.id,
                    name: nameController.text,
                    location: locationController.text,
                    date: selectedDate.toLocal().toString().split(' ')[0],
                    length: lengthController.text,
                    difficulty: difficultyController.text,
                    description: descriptionController.text,
                    parking: parkingAvailable ? "Yes" : "No",
                  );

                  await DBHelper.update('hikes', updatedHike.toMap(), hike.id);


                  // Refresh the list of hikes
                  setState(() {
                    _loadHikes();
                  });
                  if(context.mounted) Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _showHikeDetailsDialog(Hike hike) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(hike.name),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDetailText("Location: ${hike.location}"),
                _buildDetailText("Date: ${hike.date}"),
                _buildDetailText("Length: ${hike.length}"),
                _buildDetailText("Difficulty: ${hike.difficulty}"),
                _buildDetailText("Description: ${hike.description}"),
                _buildDetailText("Parking Available: ${hike.parking}"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16, // Adjust the font size as needed
          color: Colors.black, // Customize the text color
        ),
      ),
    );
  }

  // Function to show a dialog to add a new hike
  Future<void> _showAddHikeDialog() async {
    //show database current data

    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController lengthController = TextEditingController();
    final TextEditingController difficultyController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add New Hike"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Name of Hike'),
                  ),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location'),
                  ),
                  Row(
                    children: <Widget>[
                      const Text("Date of the Hike:"),
                      TextButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: lengthController,
                    decoration: const InputDecoration(labelText: 'Length of Hike'),
                  ),
                  TextField(
                    controller: difficultyController,
                    decoration:
                    const InputDecoration(labelText: 'Level of Difficulty'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  Row(
                    children: <Widget>[
                      const Text("Parking Available:"),
                      Switch(
                        value: parkingAvailable,
                        onChanged: (value) {
                          setState(() {
                            parkingAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text("Add"),
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        locationController.text.isEmpty ||
                        lengthController.text.isEmpty ||
                        difficultyController.text.isEmpty) {
                      // Check for required fields
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Validation Error"),
                            content:
                                const Text("Please fill in all required fields."),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      final newHike = {
                        'name': nameController.text,
                        'location': locationController.text,
                        'date': "${selectedDate.toLocal()}".split(' ')[0],
                        'parking': parkingAvailable ? "Yes" : "No",
                        'length': lengthController.text,
                        'difficulty': difficultyController.text,
                        'description': descriptionController.text,
                      };

                      await DBHelper.insert('hikes', newHike);

                      // Refresh the list of hikes
                      setState(() {
                        // Call a method to reload the hikes from the database
                        _loadHikes();
                      });
                      if(context.mounted) Navigator.of(context).pop();
                    }
                  }),
            ],
          );
        });
      },
    );
  }

  Future<void> _showDeleteAllHikesConfirmationDialog() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete All Hikes'),
          content: const Text('Are you sure you want to delete all hikes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                DBHelper.deleteAll('hikes'); // Create a DBHelper method to delete all hikes
                _loadHikes(); // Refresh the list of hikes
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete All'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Perform actions after confirmation, if needed
    }
  }


  // Function to display a date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _showDeleteAllHikesConfirmationDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: hikes.length,
        itemBuilder: (context, index) {
          final hike = hikes[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            confirmDismiss: (DismissDirection direction) async {
              // Show a confirmation alert
              bool confirm = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text('Are you sure you want to delete this hike?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          DBHelper.delete('hikes', hike.id);
                            _loadHikes();
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Delete'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
              return confirm;
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              title: Text(hike.name),
              subtitle: Text(hike.location),
              tileColor: Colors.grey[200],
              onTap: () {
                // Navigate to the observations screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationsScreen(hike),
                  ),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditHikeDialog(hike);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      _showHikeDetailsDialog(hike);
                    },
                  ),
                ],
              )
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHikeDialog,
        tooltip: 'Add Hike',
        child: const Icon(Icons.add),
      ),
    );
  }
}




