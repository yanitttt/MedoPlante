import 'medicament.dart';
import 'plante.dart';

class Interaction {
  final Medicament medicament;
  final Plante plante;
  final String description;

  Interaction(this.medicament, this.plante, this.description);
}