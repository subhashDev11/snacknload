import 'package:flutter/material.dart';
import 'package:snacknload/snacknload.dart';

class DialogDemoPage extends StatefulWidget {
  const DialogDemoPage({super.key});

  @override
  State<DialogDemoPage> createState() => _DialogDemoPageState();
}

class _DialogDemoPageState extends State<DialogDemoPage> {
  SnackNLoadDialogType _dialogType = SnackNLoadDialogType.enhanced;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog Examples'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Dialog Types',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 1. OK Dialog
              ElevatedButton.icon(
                onPressed: () {
                  SnackNLoad.showOkDialog(
                    title: 'Success!',
                    content: 'Your operation was completed successfully.',
                    onOk: () {
                      SnackNLoad.showSuccess('OK pressed!');
                    },
                    dialogType: _dialogType,
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Show OK Dialog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Decisive Dialog
              ElevatedButton.icon(
                onPressed: () async {
                  bool result = await SnackNLoad.showDecisiveDialog(
                    title: 'Delete Item?',
                    content:
                        'Are you sure you want to delete this item? This action cannot be undone.',
                    confirmLabel: 'Delete',
                    cancelLabel: 'Keep',
                    dialogType: _dialogType,
                  );
                  if (result) {
                    SnackNLoad.showSuccess('Item deleted!');
                  } else {
                    SnackNLoad.showInfo('Deletion cancelled');
                  }
                },
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text('Show Decisive Dialog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Action Dialog (Custom)
              ElevatedButton.icon(
                onPressed: () {
                  SnackNLoad.showActionDialog(
                    title: 'Choose an Option',
                    dialogType: _dialogType,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Please select one of the following options:'),
                        SizedBox(height: 16),
                        Icon(Icons.category, size: 48, color: Colors.blue),
                      ],
                    ),
                    actions: [
                      ActionConfig(
                        label: 'Option A',
                        onPressed: () =>
                            SnackNLoad.showInfo('Selected Option A'),
                        iconData: Icons.looks_one,
                      ),
                      ActionConfig(
                        label: 'Option B',
                        onPressed: () =>
                            SnackNLoad.showInfo('Selected Option B'),
                        iconData: Icons.looks_two,
                      ),
                      ActionConfig(
                        label: 'Cancel',
                        onPressed: () {},
                        buttonVariant: ButtonVariant.ghost,
                      ),
                    ],
                  );
                },
                icon: const Icon(Icons.list_alt),
                label: const Text('Show Custom Action Dialog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Full Screen Dialog
              ElevatedButton.icon(
                onPressed: () {
                  SnackNLoad.showFullScreenDialog(
                    title: 'Full Screen Details',
                    content: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.fullscreen,
                              size: 100, color: Colors.purple),
                          const SizedBox(height: 24),
                          const Text(
                            'This is a full screen dialog!',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'It behaves like a modal page but is built on the overlay system. '
                              'It includes a close button automatically.',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () => SnackNLoad.dismiss(),
                            child: const Text('Close Dialog'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.fullscreen),
                label: const Text('Show Full Screen Dialog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 16),

              // 5. Selection Dialog
              ElevatedButton.icon(
                onPressed: () async {
                  var selected = await SnackNLoad.showSelectionDialog<String>(
                    title: 'Select a Fruit',
                    options: [
                      SelectionOption(
                          label: 'Apple', value: 'Apple', icon: Icons.apple),
                      SelectionOption(
                          label: 'Banana',
                          value: 'Banana',
                          icon: Icons.star_border), // No banana icon
                      SelectionOption(
                          label: 'Cherry', value: 'Cherry', icon: Icons.grass),
                      SelectionOption(
                          label: 'Delete All',
                          value: 'Delete',
                          isDestructive: true),
                    ],
                    dialogType: _dialogType,
                  );
                  if (selected != null) {
                    SnackNLoad.showSuccess('Selected: $selected');
                  }
                },
                icon: const Icon(Icons.check_box_outlined),
                label: const Text('Show Selection Dialog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              // const SizedBox(height: 16),

              // 6. Input Dialog
              // ElevatedButton.icon(
              //   onPressed: () async {
              //     String? input = await SnackNLoad.showInputDialog(
              //       title: 'Enter Name',
              //       message:
              //           'Please enter your full name associated with your account.',
              //       hintText: 'John Doe',
              //       dialogType: _dialogType,
              //     );
              //     if (input != null && input.isNotEmpty) {
              //       SnackNLoad.showSuccess('Hello, $input!');
              //     }
              //   },
              //   icon: const Icon(Icons.edit_outlined),
              //   label: const Text('Show Input Dialog'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.indigo,
              //     foregroundColor: Colors.white,
              //     padding: const EdgeInsets.all(16),
              //   ),
              // ),

              const SizedBox(height: 32),
              const Text(
                'Dialog Styles',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dialogType = SnackNLoadDialogType.material;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white),
                    child: const Text('Material'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dialogType = SnackNLoadDialogType.cupertino;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white),
                    child: const Text('Cupertino'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _dialogType = SnackNLoadDialogType.enhanced;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        foregroundColor: Colors.white),
                    child: const Text('Enhanced'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
