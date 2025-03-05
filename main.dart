import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Material 3 Color Scheme
        useMaterial3: true, // Enable Material 3
        scaffoldBackgroundColor: Colors.grey[50], // Lighter background
        textTheme: const TextTheme( // Consistent text styles
          headlineLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), // Consistent style
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
            labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
        ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
              )
          )
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
  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SwiftVote'),
          titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        backgroundColor: Theme.of(context).colorScheme.primary, // Use primary color
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle), // More professional icon
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
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Add padding for spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to SwiftVote',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                'Experience seamless, secure voter verification',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center, // Center-align text
              ),
              const SizedBox(height: 32), // Increased spacing
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpPage()),
                  );
                },
                icon: const Icon(Icons.help_outline,color: Colors.white),
                label: const Text('Help'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon( // Use ElevatedButton.icon for better Material style

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateDatabasePage()),
                  );
                },
                icon: const Icon(Icons.add_circle_outline,color: Colors.white), // More descriptive icon
                label: const Text('Create Database'),
              ),
               const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerificationPage()),
                  );
                },
                icon: const Icon(Icons.verified_user,color: Colors.white), // Icon for verification
                label: const Text('Start Verification'),
              ),
              const SizedBox(height: 32), // Add spacing before the image
              Image.network(
                'https://media-hosting.imagekit.io//eb34b2ab4a5e446f/svlogo.png?Expires=1835776676&Key-Pair-Id=K2ZIVPTIP2VGHC&Signature=eJppz9v0xgddH~c4D2AQKRGxflOfnj1aJUkoL4BnEPe-LXdxY6Mo9BDIMIZ5Fh6KS1X5IA5y9Ylje~RwMcGuhPauCfOblpu9IHV~oYpbtkkt5UPRXnCZZVvH7gBqFlADL368jM9C8FYCh7MCxyEHGx1HFRudfw8UNbpjawZJMeU5msXu60WOhruA7Bhjd1dysNUT0O7z5mb3ceTrlsvYoWUwXCGeUwPY-t89M9wUS29w8fCrOOrgyDR5KEu-dWS5XA-X-25SHkbmod8gxM8IQDrw2iCLJPHNTuSxVzG2sq-yOgRejzQwRIUqr-1mFjppDzNsEsTpIGYKcRG9PRjJ~Q__', // Path to your image asset
                height: 350, // Adjust the height as need
              ),
            ],
          ),
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
    bool _isScanning = false; // Control the scanning state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voter Verification'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Use primary color
        foregroundColor: Colors.white,
        leading: IconButton( // Consistent back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0), //Consistent padding.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Please position yourself for biometric scanning',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center, // Center-align text
              ),
              const SizedBox(height: 32),

              // Face scanning UI with animation
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Circular border
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
                ),
                child:  _isScanning
                ? const CircularProgressIndicator()
                : const Icon(Icons.face, size: 100, color: Colors.grey), // Placeholder icon
              ),
              const SizedBox(height: 20),

              // Conditional text based on scanning state.
               Text(
                _isScanning? 'Scanning... Please hold your face still' :  'Ready to Scan',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),


            ElevatedButton(
              onPressed: () {
                // Start/Stop Scanning.  Simulate a Scan
                setState(() {
                  _isScanning = !_isScanning;
                });

                // Simulate scanning time
                if (_isScanning) {
                  Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        _isScanning = false;
                      });
                      // Show a result (replace with actual verification logic)
                    _showVerificationResult(context, true); //Or false for failure.
                  });
                }
              },
              child: Text(_isScanning ? 'Stop Scanning' : 'Start Scanning'),
            ),
              const SizedBox(height: 10),
              OutlinedButton.icon(  // Changed to OutlinedButton
                onPressed: () {
                  // Report functionality (Implement your logic)
                   _showReportDialog(context);
                },
                icon: const Icon(Icons.report_problem),
                label: const Text('Report Issue'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  // Manual Verification Functionality.
                  _showManualVerificationDialog(context);
                },
                icon: const Icon(Icons.assignment_ind),
                label: const Text('Manual Verification'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.deepPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }

    void _showVerificationResult(BuildContext context, bool success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(success ? 'Verification Successful' : 'Verification Failed'),
          content: Text(success
              ? 'Voter verified successfully.'
              : 'Could not verify voter. Please try again or use manual verification.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (success) {
                     // Navigate to the next screen, or update state
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
    void _showReportDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Report an Issue'),
                    content: const Text('Please describe the issue you encountered:'),
                    actions: <Widget>[
                        TextFormField( // Added a text field for reporting
                            maxLines: 4,
                            decoration: const InputDecoration(
                                hintText: "Describe the problem here...",
                                border: OutlineInputBorder(),
                            ),
                        ),
                        TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                        TextButton(
                            child: const Text('Submit'),
                            onPressed: () {
                                // Handle Report Submission
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        );
    }

    void _showManualVerificationDialog(BuildContext context){
        showDialog(
            context: context,
            builder: (context){
                return AlertDialog(
                    title: const Text('Manual Verification'),
                    content: const SingleChildScrollView(
                        child: ListBody(
                            children: <Widget>[
                                Text('Please enter the voter\'s ID:'),
                                TextField( // Field for the administrator to input the ID
                                    decoration: InputDecoration(
                                        hintText: 'Enter Voter ID',
                                    ),
                                ),
                            ],
                        ),
                    ),
                    actions: <Widget>[
                        TextButton(
                            child: const Text('Cancel'),
                            onPressed: (){
                                Navigator.of(context).pop();
                            }
                        ),
                        TextButton( // The ok button to verify manually.
                            child: const Text('Verify'),
                            onPressed: (){
                                // Verify Manually with the voter ID that is provided.
                                Navigator.of(context).pop();
                            }
                        )
                    ]
                );
            }
        );
    }
}


class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Instructions'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
           leading: IconButton( // Consistent back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(20.0),

              child: ListView(  //Use ListView for potentially long content
          children: [
           Text("SwiftVote Help", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),

            const Text("Step-by-step instructions:", style: TextStyle(fontWeight: FontWeight.bold)),  //using const for performance
            const SizedBox(height: 8),
            const ListTile(  //Use ListTile for structured content
              leading: Icon(Icons.create),
              title: Text("1. Create a Database: Upload your voter list (CSV, XLSX, JSON)."),
            ),
            const ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("2. Verification: Voters use face recognition for fast verification."),
            ),
            const ListTile(
                leading: Icon(Icons.assignment_ind),
                title: Text("3. Manual Verification: Option for manual ID verification.")
            ),

             const SizedBox(height: 24),
            Text("FAQs", style: Theme.of(context).textTheme.headlineSmall),
             const SizedBox(height: 8),

             ExpansionTile(   // Use ExpansionTile for expandable FAQs
              title: const Text("What file formats are supported?"),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text("CSV, XLSX, and JSON files are supported."),
                ),
              ],
            ),
              ExpansionTile(
              title: const Text("How does the biometric verification work?"),
              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text("SwiftVote uses advanced AI (Google Gemini & Vertex AI) for secure face recognition."),
                )
              ],
            ),
            ExpansionTile(
                title: const Text("Is my data secure?"),
                children: const [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child:   Text("Yes, SwiftVote utilizes cloud-based storage with robust security measures."),
                    )
                ]
            ),
            const SizedBox(height:24),

            const Text("Contact Support", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height:8),
            const Text("If you have any further questions, please contact us at support@swiftvote.com"),


          ],
        ),
      ),
    );
  }
}



class CreateDatabasePage extends StatefulWidget {
  @override
  _CreateDatabasePageState createState() => _CreateDatabasePageState();
}

class _CreateDatabasePageState extends State<CreateDatabasePage> {
  final _formKey = GlobalKey<FormState>();
  String _databaseName = '';
  String _uniqueIdField = '';
  PlatformFile? _pickedFile; // Store the picked file

   Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx', 'json'], // Allow only these extensions
    );

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

    void _createDatabase() {
        if(_formKey.currentState!.validate()){
          _formKey.currentState!.save();

          if(_pickedFile == null){
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please upload a file to create a database.')),
            );
            return;
          }

          //Here process the database, using _databaseName, _uniqueIdField, & _pickedFile!.path
          // ... (Database Creation Logic) ...

           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Database creation successful!'), duration: Duration(seconds: 2)),
          );
           //Success!

          //optional, you can show a success message here.
        }
    }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Database'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView( // Makes the form scrollable
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration:  InputDecoration(
                    labelText: 'Database Name',
                    border: const OutlineInputBorder(), // More Material-like
                    filled: true,
                  fillColor: Colors.grey[100]
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a database name';
                  }
                  return null;
                },
                onSaved: (value) => _databaseName = value!,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: 'Unique ID Field',
                    border: const OutlineInputBorder(),
                     filled: true,
                  fillColor: Colors.grey[100]
                ),
                value: _uniqueIdField,
                onChanged: (newValue) {
                  setState(() {
                    _uniqueIdField = newValue!;
                  });
                },
                items: <String>[
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
              const SizedBox(height: 20),

            ElevatedButton.icon(
                onPressed: _pickFile,
               icon: const Icon(Icons.upload_file),
                label: const Text('Upload Voter Data'),
              ),
              const SizedBox(height: 10),

              // Display file name if picked.
              if (_pickedFile != null) ...[
                  Text("Selected File: ${_pickedFile!.name}", style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10)
              ],


              ElevatedButton(
                onPressed: _createDatabase, //Call the function
                child: const Text('Create Database'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ProfilePage extends StatefulWidget {
  final File? profileImage;

  const ProfilePage(this.profileImage, {super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;


 Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }



  @override
  void initState() {
    super.initState();
    _profileImage = widget.profileImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
           leading: IconButton( // Consistent back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView
        padding: const EdgeInsets.all(20), //Consistent padding
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[200], // Add a background color
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ?  Icon(Icons.person, size: 80, color: Colors.grey[600])
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sharath Kumar',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8), // Add some space
            Text('COE MIT Mysore', style: Theme.of(context).textTheme.bodyMedium),
            Text('Mandya, Karnataka, India', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),

            Text('History', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card( // Use Card for a Material look
              elevation: 2, // Add a subtle shadow
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.how_to_vote, color: Colors.white),

                ),
                title: const Text('Class CR Elections'),
                subtitle: const Text('4A - 2024-10-26'), // Include date
                trailing: const Icon(Icons.arrow_forward_ios), // Consistent style
                onTap: (){
                    //Show more details on the election.
                }
              ),
            ),

            // Add more history items as needed

             Card( // Use Card for a Material look
              elevation: 2, // Add a subtle shadow
              child: ListTile(
                leading: const CircleAvatar(
                   backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.how_to_vote, color: Colors.white),
                ),
                title: const Text(' Hostel Elections'),
                subtitle: const Text('Cauvery - 2024-07-14'), // Include date
                  trailing: const Icon(Icons.arrow_forward_ios), // Consistent style
                onTap: (){}
              ),
            ),
          ],
        ),
      ),
    );
  }
}
