class TokenManager {
  String _token;

  static final TokenManager _instance = TokenManager._internal();

  TokenManager._internal() : _token = "";

  static TokenManager get instance => _instance;

  void setToken(String token) {
    _token = token;
  }

  String getToken() {
    return _token;
  }
}
