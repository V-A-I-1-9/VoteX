import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:image_picker/image_picker.dart'; // For image picking (profile)
import 'dart:io'; // For File handling (profile image)
// Add other necessary imports for Gemini/Vertex AI, CSV/XLSX/JSON parsing, etc.

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => SwiftVoteApp(),
    ),
  );
}


class SwiftVoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftVote',
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Neutral color palette
        scaffoldBackgroundColor: Colors.grey[100], // Light background
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Placeholder for profile image
  File? _profileImage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SwiftVote'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(_profileImage)),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to SwiftVote',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Experience seamless, secure voter verification',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Help page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              },
              child: Text('Help'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to Create Database page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateDatabasePage()),
                );
              },
              child: Icon(Icons.add), // Plus icon for creating a database
            ),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                // Navigate to Verification page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerificationPage()),
                );
              },
              child: Text('Start Verification'),
            ),

          ],
        ),
      ),
    );
  }
}



class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Voter Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text('Please position yourself for biometric scanning'),
            SizedBox(height: 20),

            // Placeholder for face scanning UI
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Icon(Icons.face, size: 80), // Placeholder icon
              ),
            ),
            SizedBox(height: 20),

            CircularProgressIndicator(), // Placeholder for scanning animation
            Text('Scanning... Please hold your face still'),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Report functionality
              },
              child: Text('Report'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Manual Verification functionality
              },
              child: Text('Manual Verification'),
            ),
          ],
        ),
      ),
    );
  }
}



class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Instructions'),
      ),
      body: Center( // You'll add help text content here
        child: Text('Help and instructions content will go here.'),
      ),
    );
  }
}


class CreateDatabasePage extends StatefulWidget {
  @override
  _CreateDatabasePageState createState() => _CreateDatabasePageState();
}

class _CreateDatabasePageState extends State<CreateDatabasePage> {

  // Add state variables for database creation fields (e.g., name, description, file picker)
  final _formKey = GlobalKey<FormState>();
  String _databaseName = '';
  String _uniqueIdField = ''; // To store the selected unique ID field
  // ... other fields as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Database'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Database Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a database name';
                  }
                  return null;
                },
                onSaved: (value) => _databaseName = value!,
              ),
              // ... other input fields for database details

              // Dropdown to select the unique ID field from the CSV/XLSX
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Unique ID Field'),
                value: _uniqueIdField, // Currently selected ID field
                onChanged: (newValue) {
                  setState(() {
                    _uniqueIdField = newValue!;
                  });
                },
                items: <String>[ // Replace with dynamic list from file headers
                  'voter_id',
                  'email',
                  'phone_number',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a unique ID field';
                  }
                  return null;
                },

              ),

              // File picker for CSV/XLSX/JSON upload (use file_picker package)
              ElevatedButton(
                  onPressed: () {
                    // ... File picking logic (using file_picker)
                  },
                  child: Text('Upload Voter Data')
              ),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // ... Database creation logic (using the _databaseName, _uniqueIdField, and uploaded file)
                  }
                },
                child: Text('Create Database'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ProfilePage extends StatefulWidget {
  final File? profileImage; // Receive the profile image

  ProfilePage(this.profileImage); // Constructor

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {



  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }


  File? _profileImage;  // Store the image file


  @override
  void initState() {
    super.initState();
    _profileImage = widget.profileImage; // Initialize with the passed image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            GestureDetector(  // Make the image tappable
              onTap: _pickImage, // Call _pickImage when tapped
              child: CircleAvatar(
                radius: 80,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null ? Icon(Icons.person, size: 80) : null, // Default icon
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sharath Kumar', // Replace with user's name
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('COE MIT Mysore'), // Replace with user's details
            Text('Mandya, Karnataka, India'),
            SizedBox(height: 20),


            Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Placeholder for election history
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  // ...
                ),
                title: Text('Class CR Elections'),
                subtitle: Text('4A'),
              ),
            ),
            // Add more history items as needed
          ],
        ),
      ),
    );
  }
}