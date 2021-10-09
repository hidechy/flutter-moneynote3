import 'package:get/get.dart';

class AuthController extends GetxController {}

/*

  ///
  Map _AuthOfLogin = {};

  ///
  Map get AuthOfLogin => _AuthOfLogin;

  ///
  set AuthOfLogin(Map AuthOfLogin) {
    _AuthOfLogin = AuthOfLogin;
  }

  Future<void> getAuthOfLogin({String? email, String? password}) async {
    String url = "http://toyohide.work/BrainLog/api/login";
    String body = json.encode({"email": email, "password": password});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    AuthOfLogin = (response != null) ? jsonDecode(response.body) : null;
  }

*/
