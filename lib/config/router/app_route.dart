import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app/screens/screens.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
      path: '/',
      name: CheckAuthScreen.name,
      builder: (context, state) => CheckAuthScreen()),
   GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen()),
  GoRoute(
      path: '/home',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen()),
  GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => RegisterScreen()),
  GoRoute(path: '/perfil', builder: (context, state) => const PerfilScreen()),
  GoRoute(
      path: '/historial', 
      builder: (context, state) => const HistorialScreen()),
  GoRoute(
      path: '/solicitudviaje',
      name: SolicitarViajeScreen.name,
      builder: (context, state) {
        final initialLovation = state.extra as LatLng?;
        return SolicitarViajeScreen(initialLocation: initialLovation);
      }),
  GoRoute(
      path: '/seleccionubicacion',
      name: SeleccionUbicacionScreen.name,
      builder: (context, state) {
        final textoTitulo = state.extra as String?;
        return SeleccionUbicacionScreen(textoTitulo: textoTitulo ?? "");
      }),
    GoRoute(
      path: '/mapa',
      name: MapaScreen.name,
      builder: (context, state) => const MapaScreen()),
 

]);
