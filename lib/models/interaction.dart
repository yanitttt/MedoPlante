
class Interaction {
  final int id;
  final int medicament_id;
  final int plante_id;

  // Constructeur
  Interaction(this.id, this.medicament_id, this.plante_id);

  // Getter
  int get getId => id;
  int get getMedicamentId => medicament_id;
  int get getPlanteId => plante_id;

  
}