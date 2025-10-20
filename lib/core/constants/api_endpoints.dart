// lib/core/constants/api_endpoints.dart
class ApiEndpoints {
  // ⭐ URL del backend
  static const String baseUrl = 'http://localhost:8085';
  
  // ==========================================
  // 🔐 AUTH ENDPOINTS
  // ==========================================
  static const String login = '/v1/api/auth/login';
  static const String register = '/v1/api/auth/register';
  static const String validateToken = '/v1/api/auth/validate';
  static const String logout = '/v1/api/auth/logout'; // ✅ AGREGADO
  static const String refreshToken = '/v1/api/auth/refresh';
  
  // ==========================================
  // 🏨 ROOMS ENDPOINTS
  // ==========================================
  static const String rooms = '/v1/api/rooms';
  static const String availableRooms = '/v1/api/rooms/estado/Disponible/state/A';
  
  // ==========================================
  // 📅 BOOKINGS ENDPOINTS
  // ==========================================
  static const String bookings = '/v1/api/bookings';
  static const String myBookings = '/v1/api/bookings/my-bookings';
  static const String createBooking = '/v1/api/bookings/create';
  static const String adminCreateBooking = '/v1/api/bookings/admin/create';
  
  // ==========================================
  // 👥 USERS ENDPOINTS
  // ==========================================
  static const String users = '/v1/api/user';
  
  // ==========================================
  // 💳 PAYMENTS ENDPOINTS
  // ==========================================
  static const String payments = '/v1/api/payments';
  
  // ==========================================
  // 🧾 BILLS ENDPOINTS
  // ==========================================
  static const String bills = '/v1/api/bills';
  
  // ==========================================
  // 🧹 CLEANING ENDPOINTS
  // ==========================================
  static const String cleanings = '/v1/api/cleanings';
  static const String cleaningDetails = '/v1/api/cleaning-details';
  
  // ==========================================
  // 🔧 HELPER METHODS
  // ==========================================
  
  /// Obtener usuario por ID
  static String getUserById(int id) => '$users/$id';
  
  /// Obtener habitación por ID
  static String getRoomById(int id) => '$rooms/$id';
  
  /// Obtener reserva por ID
  static String getBookingById(int id) => '$bookings/$id';
  
  /// Obtener pago por ID
  static String getPaymentById(int id) => '$payments/$id';
  
  /// Obtener factura por ID
  static String getBillById(int id) => '$bills/$id';
  
  /// Obtener limpieza por ID
  static String getCleaningById(int id) => '$cleanings/$id';
  
  /// Eliminar usuario (soft delete)
  static String deleteUser(int id) => '$users/$id';
  
  /// Restaurar usuario
  static String restoreUser(int id) => '$users/$id/restore';
  
  /// Actualizar usuario
  static String updateUser(int id) => '$users/$id';
}