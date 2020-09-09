import 'package:chatapp/src/services/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chatapp/src/services/auth.dart';
import 'package:chatapp/src/services/socket.dart';
import 'package:chatapp/src/services/users.dart';
import 'package:chatapp/src/models/user.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final UsersService usersService = UsersService();
  List<User> users = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void dispose() { 
    final SocketService socketService = Provider.of<SocketService>(context, listen: false);
    socketService.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    this._loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>( context );
    final user = authService.user;
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.name}', style: TextStyle(color: Colors.black87)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( Icons.exit_to_app, color: Colors.black87 ),
          onPressed: (){
            socketService.disconnect(); 
            Navigator.of(context).pushReplacementNamed('login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: 10,
            ),
            child: socketService.serverStatus == ServerStatus.Online 
            ? Icon( Icons.check_circle, color: Colors.green ) 
            : Icon( Icons.offline_bolt, color: Colors.red ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon( Icons.check, color: Colors.green[400] ),
          waterDropColor: Colors.blue[400],
        ),
        child: _listViewUsers(),
      ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: ( _, i ) => _listUserItem( users[i] ), 
      separatorBuilder: ( _, i ) => Divider(), 
      itemCount: users.length
    );
  }

  Widget _listUserItem( User user ){
    return ListTile(
      leading: CircleAvatar(
        child: Text('${user.name.substring(0,2)}'),
        backgroundColor: Colors.blue[100],
      ),
      title: Text('${user.name}'),
      subtitle: Text('${user.email}'),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.isOnline
          ? Colors.green[300]
          : Colors.red,
          borderRadius: BorderRadius.circular(100)
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.of(context).pushNamed('chat');
      },
    );
  }

  Future<void> _loadUsers() async {
    this.users = await usersService.getUsers();
    setState(() {});
    await Future.delayed(Duration( milliseconds: 1000 ));
    _refreshController.refreshCompleted();
  }
}