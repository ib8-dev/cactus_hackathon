import 'package:objectbox/objectbox.dart';

@Entity()
class Vector {
  @Id()
  int id;

  List<double> embedding;

  Vector({this.id = 0, required this.embedding});
}
