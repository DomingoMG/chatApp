import 'package:chatapp/src/models/usersResponse.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/src/global/enviroment.dart';
import 'package:chatapp/src/services/auth.dart';
import 'package:chatapp/src/models/user.dart';

class UsersService {

  Future<List<User>> getUsers({ int perPage, int page }) async {
    try {
      final response = await http.get(
        '${Environment.apiURL}/users',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        }
      );
      if( response.statusCode == 200 ){
        final UsersResponse usersResponse = usersResponseFromJson( response.body );
        return usersResponse.users;
      } else {
        return [];
      }
    }catch(e){
      return [];
    }
  }

}