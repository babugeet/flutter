import 'dart:html';

class AuthService {
  Future<bool> isUserSignedIn() async {
    // Check if the session token exists in Local Storage
    String? token = window.localStorage['flutter.token1']; // Retrieve the token from Local Storage
    return token != null; // Return true if the token exists, false otherwise

    // #TODO, to check time and mark expiry
  }

  Future<void> logout() async {
    // Clear the token from Local Storage on logout
    window.localStorage.remove('flutter.token1'); // Clear stored session token
  }

  Future<bool> isKeyExists(String key) async {
    // Check if a specific key exists in Local Storage
    String? value = window.localStorage[key];
    return value != null; // Return true if key exists, false otherwise
  }
}
