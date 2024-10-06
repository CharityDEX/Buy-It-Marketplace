import 'package:flutter/material.dart';

class ProfileFormItem extends StatefulWidget {
  final Icon? icon;
  const ProfileFormItem({super.key, this.icon});

  @override
  State<ProfileFormItem> createState() => _ProfileFormItemState(icon);
}

class _ProfileFormItemState extends State<ProfileFormItem> {
  final Icon? icon;
  bool? _isEditable = false;
  late FocusNode _focusNode;
  TextEditingController _controller = TextEditingController();
  _ProfileFormItemState(this.icon);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(''),
            ),
            IconButton(
                icon: const Icon(
                  Icons.edit_note,
                  color: Color(0xFF5B67CA),
                ),
                onPressed: () {
                  setState(() {
                    _isEditable = true;
                    Future.delayed(const Duration(milliseconds: 50), () {
                      FocusScope.of(context).requestFocus(_focusNode);
                    });
                  });
                })
          ],
        ),
        Container(
          height: 1,
          color: const Color(0xFFE3E8F1),
        ),
      ],
    );
  }
}
