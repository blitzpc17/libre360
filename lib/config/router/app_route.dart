import 'package:go_router/go_router.dart';
import 'package:taxi_app/Services/notifications_service.dart';
import 'package:taxi_app/screens/screens.dart';

final appRouter = GoRouter(
  navigatorKey: NotificationsService.navigatorKey,
  routes: [
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
    path: '/homechofer',
    name: HomeChoferScreen.name,
    builder: (context, state){
      final params = state.extra as Map<String, dynamic>?;
      return HomeChoferScreen(data: params);
    }
    ),
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
      builder: (context, state) =>  const SolicitarViajeScreen() ),
  GoRoute(
      path: '/seleccionubicacion',
      name: SeleccionUbicacionScreen.name,
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>;
        final String textoTitulo = params['textoTitulo'] as String;
        final bool origen = params['origen'] as bool;

        return SeleccionUbicacionScreen(textoTitulo: textoTitulo, origen: origen);
      },
    ),
    GoRoute(
      path: '/mapa',
      name: MapaScreen.name,
      builder: (context, state)  {
        final params = state.extra as bool;
        return MapaScreen(origen: params);
      }),
 

]);
