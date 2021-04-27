import 'package:http/http.dart' as http;

//Model class for assemblies. Includes all http and json functionalities
class Assemblies {
  final int pk;
  final String assemblyName;
  final int quorum;
  final String agenda;
  final bool archived;

  Assemblies(
      {this.pk, this.assemblyName, this.quorum, this.agenda, this.archived});

  factory Assemblies.fromJson(Map<String, dynamic> json) {
    return Assemblies(
      pk: json['pk'],
      assemblyName: json['assembly_name'],
      quorum: json['quorum'],
      agenda: json['agenda'],
      archived: json['archived'],
    );
  }

  //GET Request
  Future<Assemblies> fetchAssemblies() async {
    //Need to finish implementation when url is available
    return null;
  }
}
