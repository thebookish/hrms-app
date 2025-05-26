class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  static const String login = '$baseUrl/auth/login';
  static const String employeeList = '$baseUrl/employees';
  static const String leaveRequests = '$baseUrl/leaves';
  static const String salaryDetails = '$baseUrl/salary';
}
