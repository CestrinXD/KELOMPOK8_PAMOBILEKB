import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label, hint, groupValue;
  final Function? onTap;
  final Function(String?)? onChanged;
  final bool readOnly;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      this.onTap,
      this.readOnly = false,
      this.groupValue,
      this.onChanged, required String? Function(dynamic value) validator});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = false;
  bool showPassword = false; // Variable for managing show/hide password

  @override
  void initState() {
    super.initState();
    if (widget.label == "Password") {
      obscureText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hint,
              labelText: widget.label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              suffixIcon: widget.label == "Birth Date"
                  ? IconButton(
                      onPressed: () {
                        if (widget.onTap != null) {
                          widget.onTap!(); // Memanggil fungsi onTap
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                    )
                  : null,
            ),
            obscureText: obscureText,
            readOnly: widget.readOnly,
          ),
        ),
        if (widget.label == "Password") ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Checkbox(
              value: showPassword,
              onChanged: (bool? value) {
                setState(() {
                  showPassword = value ?? false;
                  obscureText = !showPassword;
                });
              },
            ),
            title: const Text('Show Password'),
          ),
        ],
        if (widget.label == "Gender") ...[
          const SizedBox(height: 5),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Pria'),
            leading: Radio<String>(
              value: 'Pria',
              groupValue: widget.groupValue,
              onChanged: widget.onChanged,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Wanita'),
            leading: Radio<String>(
              value: 'Wanita',
              groupValue: widget.groupValue,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ],
    );
  }
}
