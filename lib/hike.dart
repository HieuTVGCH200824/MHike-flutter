class Hike {
  int id;
  String name;
  String location;
  String date;
  String parking;
  String length;
  String difficulty;
  String description;

  Hike({
    required this.id,
    required this.name,
    required this.location,
    required this.date,
    required this.parking,
    required this.length,
    required this.difficulty,
    required this.description,
  });

  // Define a factory constructor to create a Hike object from a map
  factory Hike.fromMap(Map<String, dynamic> map) {
    return Hike(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      date: map['date'],
      parking: map['parking'],
      length: map['length'],
      difficulty: map['difficulty'],
      description: map['description'],
    );
  }

  // Define a function that converts the Hike object to a map
  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'date': date,
      'parking': parking,
      'length': length,
      'difficulty': difficulty,
      'description': description,
    };
  }
}
