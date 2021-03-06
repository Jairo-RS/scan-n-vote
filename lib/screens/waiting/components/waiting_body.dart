import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan_n_vote/components/backdrop.dart';
import 'package:scan_n_vote/components/round_button.dart';
import 'package:scan_n_vote/models/assemblies_model.dart';
import 'package:scan_n_vote/repositories/user_repository.dart';
import 'package:scan_n_vote/screens/motions/motions_screen.dart';

class WaitingBody extends StatelessWidget {
  final UserRepository userRepository;
  final Assemblies currentAssembly;
  WaitingBody(
      {Key key, @required this.userRepository, @required this.currentAssembly})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //Used for total height and width of the screen
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      //when back button is pressed return to desired screen
      onWillPop: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MotionsScreen(
              userRepository: userRepository,
              currentAssembly: currentAssembly,
            );
          },
        ),
      ),
      child: SafeArea(
        child: Backdrop(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Su voto ha sido contado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Text(
                  'Gracias por votar!\n\n'
                  'Favor esperar mientras los demás \nestudiantes terminan de votar.\n \n'
                  'Los resultados de las votaciones \nestarán disponibles brevemente.\n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              SvgPicture.asset(
                "assets/icons/undraw_voting.svg",
                height: size.height * 0.15,
              ),
              RoundButton(
                text: "De Vuelta a Mociones",
                color: Colors.black87,
                textColor: Colors.white,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MotionsScreen(
                          userRepository: userRepository,
                          currentAssembly: currentAssembly,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
