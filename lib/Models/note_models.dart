import 'package:isar/isar.dart';

part 'note_models.g.dart';

@Collection()
class Notes {
  Id id = Isar.autoIncrement;
  late String text;
}
