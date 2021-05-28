import 'package:flutter/material.dart';

class GroupProfile extends StatefulWidget {
  final String imageUrl;
  final String groupName;
  final users;
  GroupProfile(
      {@required this.groupName,
      @required this.imageUrl,
      @required this.users});
  @override
  _GroupProfileState createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
  List<String> groupUser = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          '${widget.groupName}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Arial Rounded",
          ),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: NetworkImage(widget.imageUrl),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.group,
                          color: Colors.purple,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Container(
                          child: Text('Group Name\n${widget.groupName}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: "Arial Rounded",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_pin_circle,
                          color: Colors.purple,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Container(
                          child: Text('Group Members',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontFamily: "Arial Rounded",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),     
              SizedBox(height:10),   
             Expanded(
                              child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: groupUser.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SizedBox(width:25),
                          Text(
                            '-  ${groupUser[index]}',
                            style: TextStyle(
                              fontFamily: "Arial Rounded",
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    insertGroupUser();
  }

  insertGroupUser() {
    for (int i = 0; i < widget.users.length; i++) {
      groupUser.add(widget.users[i]);
      print(groupUser[i]);
    }
    print('yes');
  }
}
