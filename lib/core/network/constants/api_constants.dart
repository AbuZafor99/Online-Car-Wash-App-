class ApiConstants {
  /// [Base Configuration]
  // static const String baseDomain = 'https://api.evpitch.com';

  // add by zafor
  static const String baseDomain = 'https://backend-youssefkleeno.onrender.com';
  //add by zafor end

  static const String baseUrl = '$baseDomain/api/v1';

  /// soykot ip

  //static const String soyDomain = 'http://10.10.5.91:5002';

  // static const String baseDomain = 'https://api.evpitch.com';
  // static const String baseDomain = 'http://10.10.5.3:5000'; // iftikhar
  // static const String baseUrl = '$baseDomain/api/v1';

  /// [Headers]
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
    // Content-Type will be set automatically for multipart
  };

  /// [Endpoint Groups]
  static AuthEndpoints get auth => AuthEndpoints();

  static UserEndpoints get user => UserEndpoints();
  static NotificationEndpoints get notification => NotificationEndpoints();

  static TeamEndpointcs get team => TeamEndpointcs();
  static LeagueEndpoints get league => LeagueEndpoints();

  static ContactEndpoints get contact => ContactEndpoints();

  static PaymentEndpoints get payment => PaymentEndpoints();
  static RecruiterAccountApi get recruiter => RecruiterAccountApi();
  static ScheduleEndpoints get schedule => ScheduleEndpoints();
  static VehicleEndpoints get vehicle => VehicleEndpoints();
  static ServiceEndpoints get service => ServiceEndpoints();
}

class RecruiterAccountApi {
  final String getCompany = '${ApiConstants.baseUrl}/all/companies';
}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/user';

  final String login = '$_base/login';
  final String register = '$_base/register';
  final String verify = '$_base/verify';
  final String refreshToken = '${ApiConstants.baseUrl}/auth/refresh-token';

  // Password Reset Flow
  final String resetPass = '$_base/forget'; // Send OTP for forgot password
  final String otpVerifyResetPassword =
      '$_base/verify-reset-otp'; // OTP verification for password reset
  final String otpVerifyRegister =
      '$_base/verify'; // OTP verification (register flow)
  final String changePassword =
      '$_base/change-password'; // Change password with old and new

  // Security Questions
  final String defaultSecurityQuestions =
      '${ApiConstants.baseUrl}/default-security-questions';
  final String securityAnswers = '${ApiConstants.baseUrl}/security-answers';
  final String verifySecurityAnswers =
      '${ApiConstants.baseUrl}/security-answers/verify';
  final String resetPasswordWithToken =
      '${ApiConstants.baseUrl}/security-answers/reset-password';
}

class UserEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/user';
  final String updateProfile = '$_base/update-profile';
  final String getUserProfile = '$_base/profile';

  // final String create = '$_base/create';
}

class NotificationEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/notification';

  final String getnotifications = '$_base/getnotifications';
}

class TeamEndpointcs {
  static const String _base = '${ApiConstants.baseUrl}/team';

  final String create = '$_base/create';
}

class LeagueEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/league';

  final String getAllLeagues = '$_base/all-league';
}

class ContactEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/contact';
  final String createContact = '$_base/create';
}

// New payment endpoints
class PaymentEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/payment';

  final String createPayment = '$_base/create-payment';

  final String confirmPayment = '$_base/confirm-payment';
}

// Schedule endpoints
class ScheduleEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/time';

  final String getScheduleSlots = '$_base/slots';
  final String getSlotsByDate =
      '$_base/by-date'; // {baseurl}/time/by-date?date=2025/09/13
}

//Vehicle endpoints
class VehicleEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/vehicle';
  final String getVehicles = _base;
}

//Service endpoints
class ServiceEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/service';

  ///service?washType=Monthly Subscription
  final String getServices = _base;
}

class ServiceEndpointsInstance {
  static const String _base = '${ApiConstants.baseUrl}/service';
  static const String getServices = _base;
}
