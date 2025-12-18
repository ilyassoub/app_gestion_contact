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
        title: Text(
          widget.contact.id.isEmpty ? "Ajouter un contact" : "Modifier le contact",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF9FAFB),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // NOM
                _buildLabel("Nom complet *"),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: name,
                  decoration: _buildInputDecoration(
                    hint: "Nom et Prénom",
                    icon: Icons.person_outline_rounded,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le nom est obligatoire";
                    }
                    return null;
                  },
                  onSaved: (value) => name = value ?? '',
                ),

                SizedBox(height: 20),

                // PHONE
                _buildLabel("Téléphone *"),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: phone,
                  decoration: _buildInputDecoration(
                    hint: "Ex: +212 600-000-000",
                    icon: Icons.phone_rounded,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le numéro de téléphone est obligatoire";
                    }
                    return null;
                  },
                  onSaved: (value) => phone = value ?? '',
                ),

                SizedBox(height: 20),

                // EMAIL
                _buildLabel("Email"),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: email,
                  decoration: _buildInputDecoration(
                    hint: "Ex: Nom.Prènom@gmail.com",
                    icon: Icons.email_rounded,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => email = value ?? '',
                ),

                SizedBox(height: 20),

                // NOTE
                _buildLabel("Note"),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: note,
                  decoration: _buildInputDecoration(
                    hint: "Ajoutez une note...",
                    icon: Icons.note_rounded,
                  ),
                  maxLines: 4,
                  onSaved: (value) => note = value ?? '',
                ),

                SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: Color(0xFF6366F1).withOpacity(0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_rounded, size: 24),
                        SizedBox(width: 8),
                        Text(
                          "Enregistrer",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final contact = Contact(
                          id: widget.contact.id,
                          name: name,
                          phone: phone,
                          email: email,
                          note: note,
                          favorite: widget.contact.favorite,
                        );

                        try {
                          if (widget.contact.id.isEmpty) {
                            await provider.addContact(contact);
                          } else {
                            await provider.updateContact(contact);
                          }
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Erreur lors de la sauvegarde: $e"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
        letterSpacing: 0.3,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      prefixIcon: Icon(icon, color: Color(0xFF6366F1)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
