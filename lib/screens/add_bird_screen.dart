import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

import 'package:spot_the_bird/models/bird_post_model.dart';

class AddBirdScreen extends StatefulWidget {
  final LatLng latLng;
  final File image;

  AddBirdScreen({required this.latLng, required this.image});

  @override
  _AddBirdScreenState createState() => _AddBirdScreenState();
}

class _AddBirdScreenState extends State<AddBirdScreen> {
  final _formKey = GlobalKey<FormState>();
  late final FocusNode _descriptionFocusNode;

  String? name;
  String? description;

  void _submit(BirdModel birdModel, BuildContext context) {
    if(!_formKey.currentState!.validate()){
      // Invalid!!
      return;
    }

    _formKey.currentState!.save();
    // Save to cubit
    // context.read<BirdPostCubit>().addPost(birdModel);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _descriptionFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Bird"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 1.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(widget.image),
                        fit: BoxFit.cover,
                      )),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Enter a bird name"),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    name = value!.trim();
                  },
                  onFieldSubmitted: (_) {
                    // Refocus on field decoration
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a name";
                    }
                    if (value.length < 2) {
                      return "Please enter a longer name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  decoration:
                      InputDecoration(hintText: "Enter a bird decoration"),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    final BirdModel birdModel = BirdModel(
                        image: widget.image,
                        longitude: widget.latLng.longitude,
                        latitude: widget.latLng.latitude,
                        birdDescription: description,
                        birdName: name);

                    _submit(birdModel, context);
                  },
                  onSaved: (value) {
                    description = value!.trim();
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a description";
                    }
                    if (value.length < 2) {
                      return "Please enter a longer description";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO:- Add bird post to BirdPostCubit
          // Save Bird Post

          final BirdModel birdModel = BirdModel(
              image: widget.image,
              longitude: widget.latLng.longitude,
              latitude: widget.latLng.latitude,
              birdDescription: description,
              birdName: name);

          _submit(birdModel, context);

          // Later show post on the map
        },
        child: Icon(Icons.check, size: 30),
      ),
    );
  }
}
