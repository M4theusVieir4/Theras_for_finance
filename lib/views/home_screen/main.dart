import 'package:flutter/material.dart';
import 'package:theras_app/views/menu_empresas/footer.dart';
import '../menu_empresas/main.dart';
import '../details_screen/main.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(child: SingleChildScrollView(child: _buildColumn(context)));
  }
}

Widget _buildColumn(BuildContext context) => Container(
    height: 2000,
    child: Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // First blue container
        _buildTopContainer(context),
        // Button with offset
        _buildMidContainerWithButton(context),
        // Bottom white container
        _buildBottomContainer(),
        Footer()
      ],
    ));

Widget _buildTopContainer(context) => Flexible(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          //gradient: LinearGradient(colors: [Color(0xFFC86DD7), Color(0xFF3023AE)]),
          color: Color.fromRGBO(113, 99, 255, 1),
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.5,
                      child: Image.asset(
                        "assets/company_imagens/iconeTheras.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'T H Ξ R A S',
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Home',
                        style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            color: Colors.white)),
                    SizedBox(width: 8),
                    Text('About',
                        style: TextStyle(
                            fontFamily: "Montserrat-Bold",
                            color: Colors.white)),
                    SizedBox(width: 500),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Center(
                                child: Text("Login",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        fontFamily: "Montserrat-Bold"))),
                          ),
                        ))
                  ],
                )
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Análises De Empresas com \n Machine Learning',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '''Desenvolvemos análises de empresas na bolsa brasileira com modelos de\naprendizado de máquina, com Regressão Polimonial, K-means e Redes Neurais.''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Colors.grey[300],
                    ))
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MenuEmpresas(title: 'T H Ξ R A S'),
                      ),
                    );
                  },
                  child: Container(
                    width: 250,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [(Color(0xff374ABE)), (Color(0xff64B6FF))]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Acessar cards gratuitos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          letterSpacing: 1,
                          fontFamily: "Montserrat-Bold",
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

Widget _buildMidContainerWithButton(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double containerWidth = screenWidth * 2;
  return Stack(
    children: [
      // Use same background color like the second container
      // Container(height: 0, width: containerWidth),
      // Translate the button
      Transform.translate(
        offset: Offset(0.0, -MediaQuery.of(context).size.height / 20.0),
        child: Center(
          child: Container(
              width: containerWidth,
              height: MediaQuery.of(context).size.height / 2.5,
              child: Center(
                  child: Image.asset(
                "assets/company_imagens/dashboardTHERAS.jpeg",
                scale: 1,
              ))),
        ),
      ),
    ],
  );
}

Widget _buildBottomContainer() => Flexible(
      flex: 5,
      child: Container(
        color: Color.fromRGBO(250, 250, 250, 1),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Bottom container',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ]),
      ),
    );
