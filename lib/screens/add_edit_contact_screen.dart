import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

class AddEditContactScreen extends StatefulWidget {
  final Contact contact;

  AddEditContactScreen({required this.contact});

  @override
  _AddEditContactScreenState createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();

  late String name;
  late String phone;
  late String email;
  late String note;

  @override
  void initState() {
    super.initState();
    name = widget.contact.name;
    phone = widget.contact.phone;
    email = widget.contact.email;
    note = widget.contact.note;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContactProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.isInBox ? "Modifier le contact" : "Ajouter un contact"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // NOM
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: "Nom"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le nom est obligatoire";
                  }
                  return null;
                },
                onSaved: (value) => name = value ?? '',
              ),

              SizedBox(height: 12),

              // PHONE
              TextFormField(
                initialValue: phone,
                decoration: InputDecoration(labelText: "Téléphone"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le numéro de téléphone est obligatoire";
                  }
                  return null;
                },
                onSaved: (value) => phone = value ?? '',
              ),

              SizedBox(height: 12),

              // EMAIL
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => email = value ?? '',
              ),

              SizedBox(height: 12),

              // NOTE
              TextFormField(
                initialValue: note,
                decoration: InputDecoration(labelText: "Note"),
                onSaved: (value) => note = value ?? '',
              ),

              SizedBox(height: 24),

              // BOUTON SAUVEGARDE
              ElevatedButton(
                child: Text("Enregistrer"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    widget.contact.name = name;
                    widget.contact.phone = phone;
                    widget.contact.email = email;
                    widget.contact.note = note;

                    if (widget.contact.isInBox) {
                      provider.updateContact(widget.contact);
                    } else {
                      provider.addContact(widget.contact);
                    }

                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
