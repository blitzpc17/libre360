import 'dart:convert';

class Viaje {
    String claveUsuarioConfirmo;
    String estado;
    String? fechaConfirmacion;
    String? fechaLlegada;//cuando llega al destino del cliente.. fin del viaje
    String? fechaArrivo; //cuando llega con el cliente
    String fechaSolicitud;
    String? folio;
    String precio;
    String? ubicacionDestino;
    String ubicacionOrigen;
    String tokenCliente;
    String? tokenChofer;
    String clienteId;
    String? ubicacionChofer;
    String? id;

    Viaje({
        required this.claveUsuarioConfirmo,
        required this.estado,
        this.fechaConfirmacion,
        this.fechaLlegada,
        this.fechaArrivo,
        required this.fechaSolicitud,
        this.folio,
        required this.precio,
        this.ubicacionDestino,
        required this.tokenCliente,
        required this.ubicacionOrigen,
        required this.clienteId,
        this.ubicacionChofer,
        this.tokenChofer
    });

    factory Viaje.fromJson(String str) => Viaje.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Viaje.fromMap(Map<String, dynamic> json) => Viaje(
        claveUsuarioConfirmo: json["ClaveUsuarioConfirmo"],
        estado: json["Estado"],
        fechaConfirmacion: json["FechaConfirmacion"],
        fechaLlegada: json["FechaLlegada"],
        fechaSolicitud: json["FechaSolicitud"],
        folio: json["Folio"],
        precio: json["Precio"],
        ubicacionDestino: json["UbicacionDestino"],
        ubicacionOrigen: json["UbicacionOrigen"],
        tokenCliente:  json["tokenCliente"],
        tokenChofer: json["tokenChofer"],
        ubicacionChofer: json["ubicacionChofer"],
        clienteId: json["clienteId"],
        fechaArrivo: json["fechaArrivo"] 
    );

    Map<String, dynamic> toMap() => {
        "ClaveUsuarioConfirmo": claveUsuarioConfirmo,
        "Estado": estado,
        "FechaConfirmacion": fechaConfirmacion,
        "FechaLlegada": fechaLlegada,
        "FechaSolicitud": fechaSolicitud,
        "Folio": folio,
        "Precio": precio,
        "UbicacionDestino": ubicacionDestino,
        "UbicacionOrigen": ubicacionOrigen,
        "tokenCliente":tokenCliente,
        "tokenChofer":tokenChofer,
        "clienteId":clienteId,
        "ubicacionChofer":ubicacionChofer,
        "fechaArrivo":fechaArrivo
    };
}
