import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;

  const EditProfile({
    super.key,
    this.initialName = "AMAN BHANDARI",
    this.initialEmail = "amanbh@gmail.com",
    this.initialPhone = "8171455246",
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  int? editingFieldIndex;
  bool hasChanges = false;

  // Add controllers for each text field
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  // Original values to detect changes
  late String originalName;
  late String originalEmail;
  late String originalPhone;

  // Add focus nodes for each field
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with passed values
    nameController = TextEditingController(text: widget.initialName);
    emailController = TextEditingController(text: widget.initialEmail);
    phoneController = TextEditingController(text: widget.initialPhone);

    // Store original values
    originalName = widget.initialName;
    originalEmail = widget.initialEmail;
    originalPhone = widget.initialPhone;

    // Add listeners to detect changes
    nameController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
    phoneController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      hasChanges = nameController.text != originalName ||
          emailController.text != originalEmail ||
          phoneController.text != originalPhone;
    });
  }

  @override
  void dispose() {
    // Clean up the controllers and focus nodes when the widget is disposed
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (hasChanges) {
          // Show confirmation dialog if there are unsaved changes
          final shouldDiscard = await _showDiscardChangesDialog();
          return shouldDiscard;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () async {
                if (hasChanges) {
                  final shouldDiscard = await _showDiscardChangesDialog();
                  if (shouldDiscard) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Icon(Icons.arrow_back)),
          backgroundColor: Colors.white,
          title: const Text(
            "EDIT ACCOUNT",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            if (hasChanges)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _saveAllChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Save All",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              customTextField("Name", 0, nameController, nameFocus),
              if (editingFieldIndex == 0) actionButtons(0),
              customTextField("Email", 1, emailController, emailFocus),
              if (editingFieldIndex == 1) actionButtons(1),
              customTextField("Phone Number", 2, phoneController, phoneFocus),
              if (editingFieldIndex == 2) actionButtons(2),

              // Save all changes button at bottom
              if (hasChanges && editingFieldIndex == null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveAllChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAllChanges() {
    // Create a map with the updated profile data
    final updatedProfile = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
    };

    // Return the updated profile to the previous screen
    Navigator.pop(context, updatedProfile);
  }

  Future<bool> _showDiscardChangesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Discard Changes?"),
          content: const Text(
              "You have unsaved changes. Are you sure you want to discard them?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Don't discard
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context, true), // Discard changes
              child: const Text(
                "Discard",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    // Default to false (don't discard) if dialog is dismissed
    return result ?? false;
  }

  /// Function to create a custom TextField
  Padding customTextField(String label, int index,
      TextEditingController controller, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: editingFieldIndex == index || editingFieldIndex == null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.deepOrange),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.deepOrange),
              ),
              suffixIcon:
                  editingFieldIndex != null && editingFieldIndex != index
                      ? null
                      : GestureDetector(
                          onTap: () {
                            if (editingFieldIndex == index) {
                              // Save changes for this field
                              setState(() {
                                editingFieldIndex = null;
                              });
                            } else {
                              setState(() {
                                editingFieldIndex = index;
                                // Focus on the field when editing starts
                                switch (index) {
                                  case 0:
                                    nameFocus.requestFocus();
                                    break;
                                  case 1:
                                    emailFocus.requestFocus();
                                    break;
                                  case 2:
                                    phoneFocus.requestFocus();
                                    break;
                                }
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: Text(
                              editingFieldIndex == index ? "DONE" : "EDIT",
                              style: const TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButtons(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // Save changes for this field
              setState(() {
                editingFieldIndex = null;
              });
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2.4,
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(15)),
              child: const Center(
                child: Text(
                  "Update",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Cancel editing and reset the field
              setState(() {
                switch (index) {
                  case 0:
                    nameController.text = originalName;
                    break;
                  case 1:
                    emailController.text = originalEmail;
                    break;
                  case 2:
                    phoneController.text = originalPhone;
                    break;
                }
                editingFieldIndex = null;
              });
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2.4,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 195, 177),
                  borderRadius: BorderRadius.circular(15)),
              child: const Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
