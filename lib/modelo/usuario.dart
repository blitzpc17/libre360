
import 'dart:convert';

class Usuario {
    String nombres;
    String apellidos;
    String email;
    String password;
    String telefono;
    String rol;
    DateTime fechaalta;
    String activo;
    dynamic fechabaja;
    dynamic placa;
    dynamic modelo;
    dynamic color;
    dynamic marca;
    dynamic domicilio;
    String online;
    String? tknotif;
    dynamic id;

    Usuario({
        required this.nombres,
        required this.apellidos,
        required this.email,
        required this.password,
        required this.telefono,
        required this.rol,
        required this.fechaalta,
        required this.activo,
        required this.fechabaja,
        required this.placa,
        required this.modelo,
        required this.color,
        required this.marca,
        required this.domicilio,
        required this.id,
        required this.online,
        this.tknotif
    });

    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        email: json["email"],
        password: json["password"],
        telefono: json["telefono"],
        rol: json["rol"],
        fechaalta: DateTime.parse(json["fechaalta"]),
        activo: json["activo"],
        fechabaja: json["fechabaja"],
        placa: json["placa"],
        modelo: json["modelo"],
        color: json["color"],
        marca: json["marca"],
        domicilio: json["domicilio"],
        tknotif: json["tknotif"],
        online:json["online"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "nombres": nombres,
        "apellidos": apellidos,
        "email": email,
        "password": password,
        "telefono": telefono,
        "rol": rol,
        "fechaalta": fechaalta.toIso8601String(),
        "activo": activo,
        "fechabaja": fechabaja,
        "placa": placa,
        "modelo": modelo,
        "color": color,
        "marca": marca,
        "domicilio": domicilio,
        "tknotif": tknotif,
        "online":online,
        "id": id,
    };
}
