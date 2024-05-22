
import '../modelo/models.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UsuarioService extends ChangeNotifier{
  final String _baseUrl = 'prueba23-edf7e-default-rtdb.firebaseio.com';
  final String _baseUrlAuth = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCe9OeUJjv_yc1MA8kbT4BpsbUUA9abYsc';
  final String _baseUrlLogin = 'identitytoolkit.googleapis.com';
  final storage = new FlutterSecureStorage();

  late Usuario objUsuarioSesion;

  bool isLoading = true;
  bool isSaving = true;


  UsuarioService(){

    obtenerDataStorageUsuario();

  }



  Future saveOrCreateUsuario(Usuario usuario) async {
    isSaving = true;
    notifyListeners();

    if(usuario.id == null){
      await this.createUsuario(usuario);
    }else{
      //update
    }

    isSaving = false;
    notifyListeners();



  }


  Future<String>createUsuario(Usuario usuario) async{
    
    final url = Uri.https(_baseUrlAuth, '/v1/accounts:signUp',{
      'key': _firebaseToken
    });

    final Map<String, dynamic> authData = {       
      'email':usuario.email,
      'password':usuario.password,     
      'returnSecureToken': true
    };

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic>decodedResp = json.decode(resp.body);


    if ( decodedResp.containsKey('idToken') ) {
        await storage.write(key: 'token', value: decodedResp['idToken']);
       

        final url = Uri.https( _baseUrl, 'usuarios.json',{
          'auth': decodedResp['idToken']
        });


        usuario.fechaalta = DateTime.now();
        usuario.activo="S";

        final resp = await http.post( url, body: usuario.toJson() );
        final decodedData = json.decode( resp.body );
        usuario.id = decodedData['name'];

        await storage.write(key: 'email', value: usuario.email);

        return usuario.id!;


    } else {
      return decodedResp['error']['message'];
    }

  }

  //obtener usuario
  Future<String>obtenerUsuarioXEmail(String email) async {
      final url = Uri.https( _baseUrl, 'usuarios.json',{
          'auth': await storage.read(key: 'token') ?? '',
          'orderBy': '"email"',
          'equalTo': '"$email"'
      });
      
      final resp = await http.get(url);
      Map<String, dynamic> jsonMap = json.decode(resp.body);
      String usuarioId = jsonMap.keys.first;
      Map<String, dynamic> usuarioData = jsonMap[usuarioId];
      
      return json.encode(usuarioData);
  }



  Future<String?> login( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrlLogin, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('idToken') ) 
    {
        await storage.write(key: 'token', value: decodedResp['idToken']);
        final String objSerial =  await obtenerUsuarioXEmail(email);        
        await storage.write(key: 'objUsuario', value: objSerial);
         objUsuarioSesion = Usuario.fromJson(objSerial);

        return null;
    } else {
      return decodedResp['error']['message'];
    }

  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'ruta');
    await storage.delete(key: 'token');
    await storage.delete(key: 'viajecurso');
    await storage.delete(key: 'objUsuario');
    return;
  }

  Future<String> readToken() async {

    return await storage.read(key: 'token') ?? '';

  }

  Future<void> obtenerDataStorageUsuario() async {
    final String user = await storage.read(key: 'objUsuario')??"";
    if(user==''){
      objUsuarioSesion = new Usuario(   
        nombres: "", 
        apellidos: "", 
        email: "", 
        password: "", 
        telefono: "", 
        rol: "", 
        fechaalta: new DateTime.now(), 
        activo: "N", 
        fechabaja: "", 
        placa: "", 
        modelo: "", 
        color: "", 
        marca: "",
        domicilio: "",
        id: null, 
      );
    }else{
      objUsuarioSesion = Usuario.fromJson(user);
    }
  
  }

  Future<String> validarSessionExpiro() async {
    final url = Uri.https(_baseUrlAuth, '/v1/accounts:lookup',{
      'key':_firebaseToken
    });

    String? tokenUser = await storage.read(key: "token");

    if(tokenUser!=null){

      final Map<String, dynamic> data ={
          "idToken":tokenUser
      };

      final resp = await http.post(url, body:json.encode(data));
      final Map<String,dynamic>decodedResp = json.decode(resp.body);

      if(decodedResp.containsKey('users')){
        return "";
      }

    }  
    //borrarde storage
    await storage.delete(key: 'token');
    await storage.delete(key: 'viajecurso');
    await storage.delete(key: 'objUsuario');
    await storage.delete(key: 'ruta');
    return "Tu sesión ha expirado.";
  }


   



}