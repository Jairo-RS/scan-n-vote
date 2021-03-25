// import 'package:flutter/material.dart';
// import 'package:scan_n_vote/components/text_field_container.dart';

// class RoundInputField extends StatelessWidget {
//   final FormFieldValidator<String> validator;
//   final String hintText;
//   final String labelText;
//   final IconData icon;
//   final IconData suffixIcon;
//   final ValueChanged<String> onChanged;
//   final TextInputType keyboardType;
//   const RoundInputField({
//     Key key,
//     @required GlobalKey<FormState> formkey,
//     this.hintText,
//     this.labelText,
//     this.icon,
//     this.suffixIcon,
//     this.onChanged,
//     this.keyboardType,
//     this.validator,
//   })  : _formkey = formkey,
//         super(key: key);

//   final GlobalKey<FormState> _formkey;

//   @override
//   Widget build(BuildContext context) {
//     return TextFieldContainer(
//       child: Form(
//         key: _formkey,
//         child: TextFormField(
//           validator: validator,
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             icon: Icon(
//               icon,
//               color: Colors.blueGrey,
//             ),
//             suffixIcon: Icon(
//               suffixIcon,
//               color: Colors.blueGrey,
//             ),
//             hintText: hintText,
//             labelText: labelText,
//             border: InputBorder.none,
//           ),
//           keyboardType: keyboardType,
//         ),
//       ),
//     );
//   }
// }
