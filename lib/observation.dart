
class Observation {
  int id;
  String observation;
  String time;
  String comments;
  int hikeId;

  Observation({
    required this.id,
    required this.observation,
    required this.time,
    required this.comments,
    required this.hikeId,
  });

  // Define a factory constructor to create a Observation object from a map
  factory Observation.fromMap(Map<String, dynamic> map) {
    return Observation(
      id: map['id'],
      observation: map['observation'],
      time: map['time'],
      comments: map['comments'],
      hikeId: map['hikeId'],
    );
  }

  // Define a function that converts the Observation object to a map
  Map<String, Object> toMap() {
    return {
      'id': id,
      'observation': observation,
      'time': time,
      'comments': comments,
      'hikeId': hikeId,
    };
  }

}