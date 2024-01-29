import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:salsel_express/util/themes.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  // Sample user data. Replace this with your actual user data.
  final Map<String, String> _userData = {
    'name': 'John Doe',
    'employeeId': '12345',
    'firstname': 'John',
    'lastname': 'Doe',
    'phone': '123-456-7890',
    'email': 'john.doe@example.com',
    'profilePicture':
        'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w600/2023/10/free-images.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('User Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Add action here if needed
            },
            iconSize: 28.0,
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Themes.backgroundColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: CachedNetworkImageProvider(
                        _userData['profilePicture'] ?? '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userData['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          buildDetailRow('Employee ID',
                              _userData['employeeId'] ?? '', Icons.work),
                          buildDetailRow('First Name',
                              _userData['firstname'] ?? '', Icons.person),
                          buildDetailRow('Last Name',
                              _userData['lastname'] ?? '', Icons.person),
                          buildDetailRow(
                              'Phone', _userData['phone'] ?? '', Icons.phone),
                          buildDetailRow(
                              'Email', _userData['email'] ?? '', Icons.email),
                          // Add more user details here if needed
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: primarySwatch, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
