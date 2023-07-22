import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
List<FlSpot> chartData1 = [];
List<FlSpot> chartData_media_movel = [];
List<FlSpot> chartData_sup_boll= [];
List<FlSpot> chartData_inf_boll= [];


class GraficoLinear extends StatefulWidget {
  final String cardIndex;

  GraficoLinear(this.cardIndex, {Key? key}) : super(key: key);
  
  @override
  _GraficoLinearState createState() => _GraficoLinearState();
}

class _GraficoLinearState extends State<GraficoLinear> {
  List<dynamic> view = [];
  List<dynamic> view2 = [];
  
  var inicio;
  double ?quant;
  double ?menorValor;
  double ?maiorValor;
  List <dynamic> predicaoValor = [];
  List<FlSpot> chartData = [];

  Future<List<FlSpot>> testandoFunc() async {
    
    String jsonData = await rootBundle.loadString('asset/Empresas_data/${widget.cardIndex}_cotacoes_teste.json');
    String jsonData1 = await rootBundle.loadString('asset/Empresas_data/${widget.cardIndex}_cotacoes.json');
    String jsonData2 = await rootBundle.loadString('asset/Empresas_data/${widget.cardIndex}_cotacoes_teste2.json');
    view = jsonDecode(jsonData);
    view2 = jsonDecode(jsonData1);
    Map<String, dynamic> view3 = json.decode(jsonData2);
    print(view3.keys);
    quant = view[0]['Close'].length;//determinando limites no eixo x do grafico
    
    //setando o array com os valores de cotação no grafico
    for(int a = 0; a < view[0]['Close'].length; a++){
      predicaoValor.insert(a,view[0]['Close'][a.toString()]);
      chartData.insert(a, FlSpot(a.toDouble(), view[0]['Close'][a.toString()]));
      
    }
    
    // localizando onde começam as predicoes
    view[0]['Data'].forEach((chave, valor) {
    if (valor == view2[0]['data'][("0").toString()]) {
      inicio = double.parse(chave);
    }
  });

    // setando os valores de predição no grafico
    for(int a = 0; a < view2[0]['resultado'].length; a++){
      chartData1.insert(a, FlSpot((inicio+=1).toDouble(), view2[0]['resultado'][a.toString()]));
    }
    //setando os valores de media movel no grafico plotados 14 semanas a frente 
    double contador = 13;
    for(int a = 0; a < view3['media movel'].length; a++){
      
      chartData_media_movel.insert(a, FlSpot(contador, view3['media movel'][a.toString()]));
      contador+=1;
      
    }
    // setando os valores de banda sup bollinger no grafico plotados a 14 semanas a frente 
    contador = 13;
    for(int a = 0; a < view3['banda sup boll'].length; a++){
      
      chartData_sup_boll.insert(a, FlSpot(contador, view3['banda sup boll'][a.toString()]));
      contador+=1;
      
    }
    contador = 13;
    for(int a = 0; a < view3['banda inf boll'].length; a++){
      
      chartData_inf_boll.insert(a, FlSpot(contador, view3['banda inf boll'][a.toString()]));
      contador+=1;
      
    }
    
    //determinando limites no tamanho do grafico
    menorValor = predicaoValor.reduce((valorAtual, elemento) => valorAtual < elemento ? valorAtual : elemento);
    maiorValor = predicaoValor.reduce((valorAtual, elemento) => valorAtual > elemento ? valorAtual : elemento);
    maiorValor = double.parse(maiorValor!.toStringAsFixed(0)) + 5;
    menorValor = double.parse(menorValor!.toStringAsFixed(0)) - 5;
   
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: testandoFunc(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Aqui você pode mostrar algum indicador de carregamento enquanto os dados estão sendo processados.
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          // Caso ocorra um erro durante o processamento dos dados, você pode tratar aqui.
          return Text('Erro ao carregar os dados');
        } else {
          // Quando os dados estiverem prontos, você pode construir o gráfico.
          chartData = snapshot.data ?? [];
          return LineChart(LineChartData(
      lineBarsData: [
        //cotacoes:
        LineChartBarData(
          spots: chartData,
          isCurved: false,
          dotData: const FlDotData(
            show: false,
          ),
          color: Colors.blue,
          barWidth: 3,
        ),
        //predicoes:
        LineChartBarData(
          spots: chartData1,
          isCurved: false,
          dotData: const FlDotData(
            show: false,
          ),
          color: Colors.red,
          barWidth: 3,
        ),
        //media movel:
        LineChartBarData(
          spots: chartData_media_movel,
          isCurved: false,
          dotData: const FlDotData(
            show: false,
          ),
          color: Colors.orange,
          barWidth: 3,
        ),
        // banda sup boll
        LineChartBarData(
          spots: chartData_sup_boll,
          isCurved: false,
          dotData: const FlDotData(
            show: false,
          ),
          color: const Color.fromARGB(255, 194, 98, 211),
          barWidth: 3,
        ),
        // banda inf boll
        LineChartBarData(
          spots: chartData_inf_boll,
          isCurved: false,
          dotData: const FlDotData(
            show: false,
          ),
          color: const Color.fromARGB(255, 194, 98, 211),
          barWidth: 3,
        ),
        
      ],
      borderData: FlBorderData(
          border: const Border(bottom: BorderSide(), left: BorderSide())),
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        leftTitles: AxisTitles(
            axisNameSize: 5,
            sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      minX: 0,
      maxX: quant,
      minY: menorValor,
      maxY: maiorValor,
    )
            // Resto do seu código do gráfico
          );
        }
      },
    );
  }
}















/*class GraficoLinear extends StatelessWidget {
  List<dynamic> view = [];
  
  List<dynamic> filteredView = [];
  String cardIndex;
  double ?menorValor;
  double ?maiorValor;
  List <dynamic> predicaoValor = [];
  final List<FlSpot> chartData = [
    const FlSpot(0, 2),
    const FlSpot(1, 5),
    const FlSpot(2, 4),
    const FlSpot(3, 7),
    const FlSpot(4, 6),
    const FlSpot(5, 10),
    const FlSpot(6, 9),
    const FlSpot(7, 2),
    const FlSpot(8, 5),
    const FlSpot(9, 4),
    const FlSpot(10, 7),
    const FlSpot(11, 6),
    const FlSpot(12, 10),
    const FlSpot(13, 9),
  ];
  GraficoLinear(this.cardIndex, {super.key});
  
  Future<void> testandoFunc() async {
    String jsonData = await rootBundle.loadString('asset/Empresas_data/' + cardIndex + '_fundamentalist.json');
    view = jsonDecode(jsonData);
    filteredView = view;
    print(filteredView[0]['Close']);
    
    for(int a = 0; a < chartData.length; a++){
      predicaoValor.insert(a,filteredView[0]['Close'][a.toString()]);
      chartData[a] = FlSpot(a.toDouble(), filteredView[0]['Close'][a.toString()]);
    }
    menorValor = predicaoValor.reduce((valorAtual, elemento) => valorAtual < elemento ? valorAtual : elemento);
    maiorValor = predicaoValor.reduce((valorAtual, elemento) => valorAtual > elemento ? valorAtual : elemento);
    maiorValor = double.parse(maiorValor!.toStringAsFixed(2));
    menorValor = double.parse(menorValor!.toStringAsFixed(2));
    print(maiorValor);
    print(menorValor);
    print(chartData);
   
  }
  
  @override
  LineChart build(BuildContext context) {
    testandoFunc();
    return LineChart(LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: chartData,
          isCurved: true,
          dotData: const FlDotData(
            show: false,
          ),
          color: Colors.blue,
          barWidth: 3,
        ),
      ],
      borderData: FlBorderData(
          border: const Border(bottom: BorderSide(), left: BorderSide())),
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        leftTitles: AxisTitles(
            axisNameSize: 5,
            sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      minX: 0,
      maxX: 14,
      minY: menorValor,
      maxY: maiorValor,
    ));
  }
}
*/