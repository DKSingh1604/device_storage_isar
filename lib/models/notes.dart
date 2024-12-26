import 'package:isar/isar.dart';

//dart run build_runner build
part 'notes.g.dart';

@Collection()
class Notes {
  Id id = Isar.autoIncrement;
  late String text;
}
