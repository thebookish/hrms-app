class ApiEndpoints {
  static const String baseUrl = 'https://backend-hrms-ejd4guekgxezb9an.southeastasia-01.azurewebsites.net/api';

  static const String login = '$baseUrl/auth/login';
  static const String employeeList = '$baseUrl/employees';
  static const String leaveRequests = '$baseUrl/leaves';
  static const String salaryDetails = '$baseUrl/salary';
}
