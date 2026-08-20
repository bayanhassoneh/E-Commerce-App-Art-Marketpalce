import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:art_marketplace/providers/post_provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _pricecontroller = TextEditingController();
  @override
  void dispose() {
    _descriptionController.dispose();
    _titlecontroller.dispose();
    _pricecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44.0),
        child: CupertinoNavigationBar(
          middle: Text(
            'Create Post',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //chosen image
                Consumer<PostProvider>(
                  builder: (context, provider, child) {
                    if (provider.selectedImage == null) {
                      return const SizedBox();
                    }

                    return Image.file(provider.selectedImage!);
                  },
                ),
                SizedBox(height: 15),
                //title
                TextFormField(
                  controller: _titlecontroller,
                  minLines: 1,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'add a Title',
                    labelStyle: TextStyle(
                      color: const Color.fromARGB(255, 196, 195, 195),
                    ),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 203, 201, 201),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 217, 237, 118),
                      ),
                      // borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                //price
                TextFormField(
                  controller: _pricecontroller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'add a Price',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 203, 201, 201),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 217, 237, 118),
                      ),
                      // borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                //description
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'add a Description',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 203, 201, 201),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 217, 237, 118),
                      ),
                      // borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                //post botton
                Consumer<PostProvider>(
                  builder: (context, provider, child) {
                    return Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          side: const BorderSide(
                            color: Color.fromARGB(255, 119, 117, 117),
                            width: 1,
                          ),
                        ),

                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                if (!_formkey.currentState!.validate()) {
                                  return;
                                }
                                final success = await provider.createPost(
                                  _descriptionController.text,
                                  _titlecontroller.text,
                                  double.parse(_pricecontroller.text),
                                );

                                if (success && context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                        child: provider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "post",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
