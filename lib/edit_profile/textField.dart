import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TextFieldProfile{
  final _userName = new TextEditingController();
  final _fullName = new TextEditingController();
  final _aboutUser = new TextEditingController();
  Widget nametextField() {
        return TextFormField(
          controller: _userName,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.purple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.purple,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Icons.person,
              color: Colors.purple,
            ),
            labelText: "User Name",
            helperText: "User Name can't empty",
            hintText: "User Name",
          ),
        );
    
  }

  Widget fullNameField() {
        return TextFormField(
          controller: _fullName,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.purple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.purple,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Icons.person,
              color: Colors.purple,
            ),
            labelText: "Name",
            helperText: "Name can't empty",
            hintText: "Name",
          ),
        );
    
  }

  Widget aboutField() {
        return TextFormField(
          controller: _aboutUser,
          maxLines: 4,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.purple,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.purple,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              MdiIcons.alertCircleOutline,
              color: Colors.purple,
            ),
            labelText: "About",
            helperText: "About field can't empty",
            hintText: "About",
          ),
        );

  }

}