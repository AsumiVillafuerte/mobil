import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Services
import 'core/services/storage_service.dart';
import 'core/services/token_service.dart';
import 'core/services/http_service.dart';

// APIs
import 'data/datasources/remote/auth_api.dart';
import 'data/datasources/remote/users_api.dart';
import 'data/datasources/remote/rooms_api.dart'; // ✅ 1. Importar RoomsApi

// Repositories
import 'data/repositories/auth_repository.dart';
import 'data/repositories/users_repository.dart';
import 'data/repositories/rooms_repository.dart'; // ✅ 2. Importar RoomsRepository

// Providers
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/users_provider.dart';
import 'presentation/providers/rooms_provider.dart'; // ✅ 3. Importar RoomsProvider

// Config
import 'core/config/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inicializar StorageService
  final storageService = StorageService();
  await storageService.init();

  // ✅ Inicializar TokenService
  final tokenService = TokenService(storageService);

  // ✅ Inicializar HttpService
  final httpService = HttpService(tokenService);

  // ✅ Inicializar APIs
  final authApi = AuthApi(httpService);
  final usersApi = UsersApi(httpService);
  final roomsApi = RoomsApi(httpService); // ✅ 4. Inicializar RoomsApi

  // ✅ Inicializar Repositories
  final authRepository = AuthRepository(authApi, tokenService, storageService);
  final usersRepository = UsersRepository(usersApi);
  final roomsRepository = RoomsRepository(roomsApi); // ✅ 5. Inicializar RoomsRepository

  // ✅ Ejecutar la app
  runApp(MyApp(
    authRepository: authRepository,
    usersRepository: usersRepository,
    roomsRepository: roomsRepository, // ✅ 6. Pasar RoomsRepository a MyApp
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final UsersRepository usersRepository;
  final RoomsRepository roomsRepository; // ✅ 7. Añadir propiedad para RoomsRepository

  const MyApp({
    super.key,
    required this.authRepository,
    required this.usersRepository,
    required this.roomsRepository, // ✅ 8. Requerir en el constructor
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
        // Users Provider
        ChangeNotifierProvider(
          create: (_) => UsersProvider(usersRepository),
        ),
        // Rooms Provider
        ChangeNotifierProvider(
          create: (_) => RoomsProvider(roomsRepository), // ✅ 9. Añadir RoomsProvider
        ),
        // 🔮 Aquí puedes agregar más providers en el futuro...
      ],
      child: MaterialApp(
        title: 'Hotel Manager',
        debugShowCheckedModeBanner: false,
        
        // 🎨 Tema de la aplicación
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF1565C0),
          useMaterial3: true,
          
          // AppBar Theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          // Elevated Button Theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
          
          // Text Button Theme
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1565C0),
            ),
          ),
          
          // Outlined Button Theme
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1565C0),
              side: const BorderSide(color: Color(0xFF1565C0)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          // Input Decoration Theme
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          
          // Card Theme
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
          ),
          
          // FloatingActionButton Theme
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF1565C0),
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          
          // Chip Theme
          chipTheme: ChipThemeData(
            backgroundColor: Colors.grey.shade200,
            selectedColor: const Color(0xFF1565C0),
            labelStyle: const TextStyle(fontSize: 14),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        
        // 🗺 Rutas
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}