import 'package:flutter/material.dart';

import 'package:password_manager/data/repositories/password_reposistory.dart';
import 'package:password_manager/domain/entities/password.dart';

class PasswordManagerScreen extends StatefulWidget {
  final PasswordRepository passwordRepository;

  PasswordManagerScreen(this.passwordRepository);

  @override
  _PasswordManagerScreenState createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  TextEditingController _siteController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Map<String, Password> passwords = {};

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  void _loadPasswords() async {
    final allPasswords = await widget.passwordRepository.getAllPasswords();
    setState(() {
      passwords = allPasswords.map(
        (site, password) => MapEntry(site, Password(site, password)),
      );
    });
  }

  void _savePassword() async {
    String site = _siteController.text;
    String password = _passwordController.text;

    await widget.passwordRepository.savePassword(site, password);

    _siteController.clear();
    _passwordController.clear();
    _loadPasswords();
  }

  void _togglePasswordVisibility(String site) {
    setState(() {
      passwords[site]!.isVisible = !passwords[site]!.isVisible;
    });
  }

  void _deletePassword(String site) async {
    await widget.passwordRepository.deletePassword(site);
    _loadPasswords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Password Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _siteController,
              decoration: InputDecoration(labelText: 'Website/Service'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
          ),
          ElevatedButton(
            onPressed: _savePassword,
            child: Text('Save Password'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: passwords.length,
              itemBuilder: (context, index) {
                String site = passwords.keys.elementAt(index);
                Password password = passwords.values.elementAt(index);
                return ListTile(
                  title: Text(site),
                  subtitle: Text(
                    password.isVisible ? password.password : '********',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          password.isVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => _togglePasswordVisibility(site),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deletePassword(site),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
