import 'package:credito_inteligente/screens/login.dart';
import 'package:credito_inteligente/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Tu Perfil',
          style: GoogleFonts.readexPro(
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
        //create a back lo login button in the right side of the app bar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 35),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rounded Image
                ClipOval(
                  child: Image.network(
                    "https://www.shutterstock.com/image-vector/user-profile-icon-vector-avatar-600nw-2247726673.jpg",
                    scale: 1.0,
                    fit: BoxFit.cover, // Make the image cover the circle avatar
                    width: 200,
                    height: 200,
                  ),
                ),

                // Name and Last Name
                Text('Name: ${widget.user.name}',
                    style: GoogleFonts.readexPro(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    )),
                Text(
                  'Last Name: ${widget.user.lastname}',
                  style: GoogleFonts.readexPro(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                // Email
                Text(
                  'Email: ${widget.user.email}',
                  style: GoogleFonts.readexPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                // Password with show/hide icon
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Password:',
                        style: GoogleFonts.readexPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          obscureText: !_isPasswordVisible,
                          initialValue: widget.user.password,
                          readOnly: true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
