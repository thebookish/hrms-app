import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_model.dart';

// Holds the logged-in user after successful login
final loggedInUserProvider = StateProvider<UserModel?>((ref) => null);
