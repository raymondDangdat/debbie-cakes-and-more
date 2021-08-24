import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:untitled/constants/controllers.dart';
import 'package:untitled/constants/firebase.dart';
import 'package:untitled/models/cake.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class EditProductsScreen extends StatefulWidget {
  final ProductModel product;

  const EditProductsScreen({Key key, this.product}) : super(key: key);
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  // final TextEditingController categoryController = TextEditingController();

  // final TextEditingController nameController = TextEditingController();

  // final TextEditingController priceController = TextEditingController();


  FirebaseStorage storage = FirebaseStorage.instance;





  bool isUploading = false;



  File file;
  UploadTask task;

  handleTakePhoto(BuildContext context) async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);

    setState(() {
      this.file = file;
    });
  }



  bool _isFormValidated() {
    final FormState form = formState.currentState;
    return form.validate();
  }

  handleChooseFromGallery(BuildContext context) async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload cake from"),
            children: [
              SimpleDialogOption(
                  child: Text("Camera"),
                  onPressed:(){
                    handleTakePhoto(context);
                  }
              ),
              SimpleDialogOption(
                  child: Text("Gallery"),
                  onPressed: (){
                    handleChooseFromGallery(context);
                  }
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  clearImage() {
    file = null;
  }
  @override
  void initState() {
    // TODO: implement initState
    editProductController.cakeCategory.text = widget.product.category;
    editProductController.cakeName.text = widget.product.name;
    editProductController.cakeDescription.text = widget.product.description;
    editProductController.cakePrice.text = widget.product.price.toString();
    super.initState();
  }

  Future uploadFile() async {
    if (file == null){
      editProductController.updateToFirestore(widget.product.id);
    }else{

      final fileName = basename(file.path);
      final destination = 'products/$fileName';

      task = FirebaseApi.uploadFile(destination, file);
      setState(() {});

      if (task == null) return;

      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      if(urlDownload != null){
        await editProductController.uploadFile(file, widget.product.id);
      }else{
        Fluttertoast.showToast(msg: "Image could not be uploaded!");
      }
    }

  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    img.Image imageFile = img.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_${widget.product.id}.jpg')
      ..writeAsBytesSync(img.encodeJpg(imageFile, quality: 90));

    setState(() {
      file = compressedImageFile;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.grey.withOpacity(.1),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Edit Cake",
            style: TextStyle(color: Colors.black),
          ),

        ),
        body: SafeArea(child:
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          physics: BouncingScrollPhysics(),
          child: Form(
              key: formState,
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      selectImage(context);
                    },
                    child: Container(height: 200, width: 200,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(image: file == null ?  NetworkImage(widget.product.image) : FileImage(file), fit: BoxFit.cover)
                      ),),
                  ),

                  SizedBox(height: 10,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: editProductController.cakeCategory,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: 'Cake Category'),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      addProductController.cakeCategory.text = value;
                    },
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Please enter a valid category name';
                      } else
                        return null;
                    },
                  ),

                  TextFormField(
                    controller: editProductController.cakeName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: 'Cake Name'),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {

                    },
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Please enter a valid cake name';
                      } else
                        return null;
                    },
                  ),

                  TextFormField(
                    controller: editProductController.cakeDescription,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: 'Cake Description'),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {

                    },
                    validator: (value) {
                      if (value.length < 10) {
                        return 'Please enter a valid cake description';
                      } else
                        return null;
                    },
                  ),

                  TextFormField(
                    controller: editProductController.cakePrice,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: 'Cake Price'),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {

                    },
                    validator: (value) {
                      if (value.length < 3) {
                        return 'Please enter a valid cake price';
                      } else
                        return null;
                    },
                  ),

                  SizedBox(height: 50,),

                  ElevatedButton(onPressed: (){
                    if(_isFormValidated()){
                      uploadFile();
                    }
                  }, child: Text("Update Cake"))
                ],
              )),
        ))
    );
  }
}
