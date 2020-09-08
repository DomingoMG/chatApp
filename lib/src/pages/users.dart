import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chatapp/src/models/user.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final users = [
    User(uid: '1', name: 'Lisbety', email: 'Lisbety72@gmail.com', isOnline: true),
    User(uid: '2', name: 'Melisa',  email: 'Melisa@gmail.com', isOnline: false),
    User(uid: '3', name: 'Adrián',  email: 'AdrianGDR@gmail.com', isOnline: false),
    User(uid: '4', name: 'Jonatan', email: 'JonatanMG94@gmail.com', isOnline: true),
  ];

  RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi nombre', style: TextStyle(color: Colors.black87)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon( Icons.exit_to_app, color: Colors.black87 ),
          onPressed: (){},
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: 10,
            ),
            child: Icon( Icons.check_circle, color: Colors.red ),
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
    );
  }

  Future<void> _loadUsers() async {
    await Future.delayed(Duration( milliseconds: 1000 ));
    _refreshController.refreshCompleted();
  }
}