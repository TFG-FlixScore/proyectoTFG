class Amigo {
  final String nombre;
  final int amigosEnComun;
  final String? imagenPerfil;
  final String? documentID;

  Amigo({
    required this.nombre,
    required this.amigosEnComun,
    this.imagenPerfil,
    this.documentID,
  });
}