import 'package:flutter/material.dart';
import 'package:mhike_flutter/sql_helper.dart';

import 'hike.dart';
import 'observation.dart'; // Import your DBHelper class

class ObservationsScreen extends StatefulWidget {
  final Hike selectedHike;
  const ObservationsScreen(this.selectedHike, {super.key});

  @override
  State<ObservationsScreen> createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends State<ObservationsScreen> {
  List<Observation> observations = [];
  List<Observation> filteredObservations = []; // Add a filtered list
  TextEditingController searchController = TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    _loadObservations();
  }

  void _loadObservations() async {
    final data = await DBHelper.getObservationsForHike(widget.selectedHike.id);
    setState(() {
      observations.clear();
      observations.addAll(data.map((item) => Observation.fromMap(item)));

      filteredObservations = List.from(observations);
    });
  }

  void _searchObservations(String query) {
    setState(() {
      filteredObservations = observations
          .where((observation) =>
          observation.observation.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  //show add observation dialog
  void _showNewObservationDialog() {
    TimeOfDay selectedTime = TimeOfDay.now(); // Initialize with the current time

    TextEditingController observationController = TextEditingController();
    TextEditingController commentsController = TextEditingController();

    // Create a dialog for entering a new observation
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Observation'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: observationController,
                  decoration: const InputDecoration(labelText: 'Observation'),
                ),
                TextButton(
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );

                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Text('Select Time: ${selectedTime.format(context)}'),
                ),
                TextField(
                  controller: commentsController,
                  decoration: const InputDecoration(labelText: 'Comments'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                // Check if the observation field is empty
                if (observationController.text.isEmpty || commentsController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Observation and comments fields cannot be empty'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }else{
                // Add the observation to the database
                final newObservation = {
                  'observation': observationController.text,
                  'time': selectedTime.format(context),
                  'comments': commentsController.text,
                  'hikeId': widget.selectedHike.id,
                };

                await DBHelper.insertObservation(newObservation);

                _loadObservations();
                if(context.mounted) Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  //show edit observation dialog
  void _showEditObservationDialog(Observation observation) {
    TimeOfDay selectedTime = TimeOfDay.now(); // Initialize with the current time

    TextEditingController observationController = TextEditingController(text: observation.observation);
    TextEditingController commentsController = TextEditingController(text: observation.comments);

    // Create a dialog for entering a new observation
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Observation'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: observationController,
                  decoration: const InputDecoration(labelText: 'Observation'),
                ),
                TextButton(
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );

                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Text('Select Time: ${selectedTime.format(context)}'),
                ),
                TextField(
                  controller: commentsController,
                  decoration: const InputDecoration(labelText: 'Comments'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                // Check if the observation field is empty
                if (observationController.text.isEmpty || commentsController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Observation and comments fields cannot be empty'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }else{
                // Add the observation to the database
                final newObservation = {
                  'observation': observationController.text,
                  'time': selectedTime.format(context),
                  'comments': commentsController.text,
                  'hikeId': widget.selectedHike.id,
                };

                await DBHelper.updateObservation(newObservation, observation.id);

                _loadObservations();
                if(context.mounted) Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
  //show observation's detail on tap
  void _showObservationDetail(Observation observation) {
    // Create a dialog for entering a new observation
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //set tittle to observation.observation
          title: Text(observation.observation),
          content: SingleChildScrollView(
           //column with padding space between
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Time: ${observation.time}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Comments: ${observation.comments}'),
                ),
              ],
            ),

          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Observations for ${widget.selectedHike.name}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                _searchObservations(query);
              },
              decoration: const InputDecoration(
                labelText: 'Search Observations',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Hike Name: ${widget.selectedHike.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Location: ${widget.selectedHike.location}'),
              ],
            ),
          ),
          const Divider(), // Add a horizontal divider for separation

          Expanded(
            child: ListView.builder(
              itemCount: filteredObservations.length,
              itemBuilder: (context, index) {
                final observation = filteredObservations[index];
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
                          content: const Text('Are you sure you want to delete this observation?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                DBHelper.deleteObservation(observation.id);
                                _loadObservations();
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
                      title: Text(observation.observation),
                      subtitle: Text(observation.comments),
                    onTap: () {
                      _showObservationDetail(observation);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditObservationDialog(observation);
                      },
                    )
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewObservationDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}