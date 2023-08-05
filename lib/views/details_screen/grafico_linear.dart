import 'dart:convert';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class JsonLoader {
  static Future<List<dynamic>> loadJsonData(String fileName) async {
    try {
      String jsonData = await rootBundle.loadString(fileName);
      return jsonDecode(jsonData);
    } catch (e) {
      throw Exception('Erro ao carregar o arquivo JSON: $e');
    }
  }
}

class GraficoLinear extends StatefulWidget {
  final String cardIndex;
  late String indicator;
  late String tipoGrafico;
  late int tickEmpresa;
  GraficoLinear(this.cardIndex, this.indicator, this.tipoGrafico, this.tickEmpresa, {Key? key}) : super(key: key);

  @override
  _GraficoLinearState createState() => _GraficoLinearState();
}

class Pair<T1, T2> {
  final T1 a;
  final T2 b;

  Pair(this.a, this.b);
}

class _GraficoLinearState extends State<GraficoLinear> {
  List<String> Real_X = [];
  List<FlSpot> Real_Y = [];

  
  

  List<Tuple3<int, String, double>> chartData = [];
  List<Tuple3<int, String, double>> chartData_pred = [];

  List<Tuple2<String, double>> chartDataCotacoes= [];
  List<Tuple2<String, double>> chartDataCotacoes_pred = [];
  
List<Tuple2<String, double>> chartDataMediaMovel = [];
List<Tuple2<String, double>> chartDataMediaMovel_pred = [];

List<Tuple2<String, double>> chartDataRSI = [];
List<Tuple2<String, double>> chartDataRSI_pred = [];

List<Tuple2<String, double>> chartDataBandaSupBoll= [];
List<Tuple2<String, double>> chartDataBandaSupBoll_pred= [];

List<Tuple2<String, double>> chartDataBandaInfBoll = [];
List<Tuple2<String, double>> chartDataBandaInfBoll_pred= [];

List<Tuple2<String, double>> chartDataMACD= [];
List<Tuple2<String, double>> chartDataMACD_pred= [];

  List<Tuple3<int, String, double>>? lastTuplePred = [];
  
  double? menorValor;
  double? maiorValor;
  String? name1;
  String? name2;
  late String name3;
  late String name4;
  late String name5;
  late String name6;
  
  bool dataLoaded = false;
  
  bool hasError = false;
  late ZoomPanBehavior _zoomPanBehavior;
  late TooltipBehavior _tooltipBehavior;
  @override
  Future<void> _carregarDados() async {
    try {
      
      late List<dynamic> dataList;

      late List<dynamic> dataLista;
      late List<dynamic> dataLista1;
      late List<dynamic> dataLista2;
      late List<dynamic> dataLista3;
      
      switch (widget.indicator) {
        
        case 'Patrimônio Líquido':
          dataList = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_Patrimônio_Líquido.json',
          );

          name1 = "PL";
          name2 = "PL Predição";

          break;

        case 'Lucro Líquido':
          dataList = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_Lucro_Prejuízo_do_Período.json',
          );
          name1 = 'Lucro Líquido';
          name2 = "Lucro Líquido Predição";
          break;
        case 'Dividendos':
          dataList = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_dividends.json',
          );
          name1 = 'Dividendos';
          name2 = "Dividendos Predição";
          break;
        case 'Receita Líquida':
          dataList = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_Receita.json',
          );
          name1 = 'Receita Líquida';
          name2 = "Receita Líquida Predição";
          break;
        case 'Despesas Trabalhistas':
          dataList = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_Obrigações_Sociais_e_Trabalhistas.json',
          );
          name1 = 'Despesas Trabalhistas';
          name2 = 'Despesas Trabalhistas Predição';
          break;
        case 'Passivo Total':
          dataList = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_Passivo_Total.json',
          );
          name1 = 'Passivo Total';
          name2 = 'Passivo Total Predição';
          break;
        case 'Contas a Receber':
          dataList = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_Contas_a_Receber.json',
          );
          name1 = 'Contas a Receber';
          name2 = 'Contas a Receber Predição';
          break;
        case 'Reservas de Lucro':
          dataList = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_Reservas_de_Lucro.json',
          );
          name1 = 'Reservas de Lucro';
          name2 = 'Reservas de Lucro Predição';
          break;

        case 'Média Móvel 14':
        
        
          dataLista = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_cotacoes.json',
          );
          dataLista1 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_cotacoes_predicao.json',
          );
          dataLista2 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_media_movel.json',
          );
          dataLista3 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_media_movel_predicao.json',
          );
          
          
          name1 = 'Cotações';
          name2 = 'Cotações Predição';
          name3 = 'Média Móvel';
          name4 = 'Média Móvel Predição';
          //name2 = 'Reservas de Lucro Predição';
          break;
        case "RSI":
        
        
          dataLista = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_cotacoes.json',
          );
          dataLista1 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_cotacoes_predicao.json',
          );
          dataLista2 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_rsi.json',
          );
          dataLista3 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_rsi_predicao.json',
          );
          name1 = 'Indice de Força Relativa';
          name2 = 'Indice de Força Relativa Predição';
        break;
        case "Bollinger Bands":
       
          dataLista = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_cotacoes.json',
          );
          dataLista1 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_cotacoes_predicao.json',
          );
          dataLista2 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_bandas_boll.json',
          );
          dataLista3 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_bandas_boll_predicao.json',
          );
          name1 = 'Cotações';
          name2 = 'Cotações Predição';
          name3 = 'Banda Inf Bollinger';
          name4 = 'Banda Inf Bollinger Pred.';
          name5 = 'Banda Sup. Bollinger';
          name6 = 'Banda Sup. Bollinger Pred.';

          

        break;
        case "MACD":
          dataLista = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_cotacoes.json',
          );
          dataLista1 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_cotacoes_predicao.json',
          );
          dataLista2 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_macd.json',
          );
          dataLista3 = await JsonLoader.loadJsonData(
            'asset/Empresas_data/${widget.cardIndex}_macd_predicao.json',
          );
          name1 = 'Média Móvel Convergente e Divergente';
          name2 = 'Média Móvel Convergente e Divergente Pred.';
        break;


        default:
          dataLista = [];
          dataList = [];
          dataLista1 = [];
          dataLista2 = [];
          dataLista3 = [];

      }
      // carregar dados de finanças
      if (widget.tipoGrafico == 'Finanças'){

        chartData = dataList.where((data) => data['info'] == 'real').map((data) {
          int index = data['index'];
          String label = data['data'];
          double valor = data['valor'];
          DateTime parsedDate = DateTime.parse(label);
          String formattedDate = DateFormat('MMM-yy').format(parsedDate);
          return Tuple3(index, formattedDate, valor);
        }).toList();

        chartData_pred =
          dataList.where((data) => data['info'] == 'prev').map((data) {
          int index = data['index'];
          String label = data['data'];
          double valor = data['valor'];
          DateTime parsedDate = DateTime.parse(label);

          String formattedDate = DateFormat('MMM-yy').format(parsedDate);
          return Tuple3(index, formattedDate, valor);
        }).toList();

      //Aqui ele arruma aquele buraquinho no gráfico
        chartData.add(chartData_pred.first);
      }
      else{ //carregar dados de price
          
          //if(widget.indicator == "Média Móvel 14" || widget.indicator == "Bollinger Bands"){
             //pegando os dados de cotacao  
          int a = 0;
          //print((dataLista[widget.tickEmpresa]['Close'].length));
          for (a; a < (dataLista[widget.tickEmpresa]['Close'].length); a++) {
          String label = dataLista[widget.tickEmpresa]['Data'][a.toString()];
          DateTime parsedDate = DateTime.parse(label);
          String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
            chartDataCotacoes.insert(a, Tuple2(formattedDate,dataLista[widget.tickEmpresa]['Close'][a.toString()]));
          }
          
          //pegando os dados de predicao  de cotacao
          int contador = 0;
          
          int tamanho_elementos = a + 13;
          
          for (a; a < tamanho_elementos; a++) {
          
          String label = dataLista1[widget.tickEmpresa]['data'][a.toString()];
          
          DateTime parsedDate = DateTime.parse(label);
          String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

            if(contador == 0){
              String label1 = dataLista[widget.tickEmpresa]['Data'][(a-1).toString()];
                
              DateTime parsedDate1 = DateTime.parse(label1);
              String formattedDate1 = DateFormat('dd/MM/yyyy').format(parsedDate1);
              chartDataCotacoes_pred.insert(contador, Tuple2(formattedDate1,dataLista[widget.tickEmpresa]['Close'][(a-1).toString()]));
              //print(dataLista[widget.tickEmpresa]['Close'][(a-1).toString()]);
              
            }
            contador++;
            chartDataCotacoes_pred.insert(contador, Tuple2(formattedDate,dataLista1[widget.tickEmpresa]['resultado'][a.toString()]));
            
            
          
          }    
          
          //}
          
          switch(widget.indicator){
            case "Média Móvel 14":
            
              int contador = 0;
              int a = 14;
              int quantidade_elementos = (dataLista2[widget.tickEmpresa]['media movel'].length)+a;

              
              for (a; a < quantidade_elementos; a++) {
                String label = dataLista[widget.tickEmpresa]['Data'][a.toString()];
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
                
                chartDataMediaMovel.insert(contador, Tuple2(formattedDate,dataLista2[widget.tickEmpresa]['media movel'][a.toString()]));
                contador++;
              }

              quantidade_elementos = quantidade_elementos + 14;
              int contador_pred = 0;
              //print(quantidade_elementos);
              //print(a);
             
             for (a; a < quantidade_elementos; a++) {
                //print(a);
                String label = dataLista1[widget.tickEmpresa]['data'][a.toString()];
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

                if(contador_pred == 0){
                  
                  chartDataMediaMovel_pred.insert(contador_pred, chartDataMediaMovel[a-15]);
                }

                contador_pred++;
                
                chartDataMediaMovel_pred.insert(contador_pred, Tuple2(formattedDate,dataLista3[widget.tickEmpresa]['media movel'][a.toString()]));
                
                
              }


          
            break;
            case "RSI":
          
              int contador = 0;
              int a = 14;
              int quantidade_elementos = (dataLista2[widget.tickEmpresa]['Ind-forc-relat'].length)+a;

              
              for (a; a < quantidade_elementos; a++) {
                String label = dataLista[widget.tickEmpresa]['Data'][a.toString()];
                
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
                
                chartDataRSI.insert(contador, Tuple2(formattedDate, dataLista2[widget.tickEmpresa]['Ind-forc-relat'][a.toString()]));
                contador++;
              }
              quantidade_elementos = quantidade_elementos + 14;
              int contador_pred = 0;
              //print(quantidade_elementos);
              //print(a);
             
             for (a; a < quantidade_elementos; a++) {
                //print(a);
                String label = dataLista1[widget.tickEmpresa]['data'][a.toString()];
                
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
                //print(dataLista[widget.tickEmpresa]['Data'][(a-1).toString()]);
                //print(dataLista2[widget.tickEmpresa]['Ind-forc-relat'][(a-1).toString()]);
                if(contador_pred == 0){
                  String label1 = dataLista[widget.tickEmpresa]['Data'][(a-1).toString()];
                
                  DateTime parsedDate1 = DateTime.parse(label1);
                  String formattedDate1 = DateFormat('dd/MM/yyyy').format(parsedDate1);
                  chartDataRSI_pred.insert(contador_pred, Tuple2(formattedDate1,dataLista2[widget.tickEmpresa]['Ind-forc-relat'][(a-1).toString()]));
                }

                contador_pred++;
                //print(dataLista3);
                chartDataRSI_pred.insert(contador_pred, Tuple2(formattedDate,dataLista3[widget.tickEmpresa]['Ind-forc-relat'][a.toString()]));  
                
              }
            break;
            case "Bollinger Bands":
            //carregando dados da banda inferior
              int contador = 0;
              int a = 14;
              int quantidade_elementos = (dataLista2[widget.tickEmpresa]['banda inf boll'].length)+a;

              
              for (a; a < quantidade_elementos; a++) {
                String label = dataLista[widget.tickEmpresa]['Data'][a.toString()]; //default data
                
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
                
                chartDataBandaInfBoll.insert(contador, Tuple2(formattedDate, dataLista2[widget.tickEmpresa]['banda inf boll'][a.toString()]));
                contador++;
              }
              //carregando dados da banda inferior predicao
              quantidade_elementos = quantidade_elementos + 14;
              int contador_pred = 0;
              
             
             for (a; a < quantidade_elementos; a++) {
                //print(a);
                String label = dataLista1[widget.tickEmpresa]['data'][a.toString()];
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

                if(contador_pred == 0){
                  String label1 = dataLista[widget.tickEmpresa]['Data'][(a-1).toString()];
                
                  DateTime parsedDate1 = DateTime.parse(label1);
                  String formattedDate1 = DateFormat('dd/MM/yyyy').format(parsedDate1);
                  chartDataBandaInfBoll_pred.insert(contador_pred, Tuple2(formattedDate1,dataLista2[widget.tickEmpresa]['banda inf boll'][(a-1).toString()]));
                }

                contador_pred++;
                
                chartDataBandaInfBoll_pred.insert(contador_pred, Tuple2( formattedDate,dataLista3[widget.tickEmpresa]['banda inf boll'][a.toString()]));     
                  
              }


              //carregando dados da banda superior
              contador = 0;
              a = 14;
              quantidade_elementos = (dataLista2[widget.tickEmpresa]['banda sup boll'].length)+a;

              
              for (a; a < quantidade_elementos; a++) {
                String label = dataLista[widget.tickEmpresa]['Data'][a.toString()]; //default data
                
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
                
                chartDataBandaSupBoll.insert(contador, Tuple2(formattedDate, dataLista2[widget.tickEmpresa]['banda sup boll'][a.toString()]));
                contador++;
              }
              //carregando dados da banda superior predicao
              quantidade_elementos = quantidade_elementos + 14;
              contador_pred = 0;
              
             
             for (a; a < quantidade_elementos; a++) {
                //print(a);
                String label = dataLista1[widget.tickEmpresa]['data'][a.toString()];
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

                if(contador_pred == 0){
                  String label1 = dataLista[widget.tickEmpresa]['Data'][(a-1).toString()];
                
                  DateTime parsedDate1 = DateTime.parse(label1);
                  String formattedDate1 = DateFormat('dd/MM/yyyy').format(parsedDate1);
                  chartDataBandaSupBoll_pred.insert(contador_pred, Tuple2(formattedDate1,dataLista2[widget.tickEmpresa]['banda sup boll'][(a-1).toString()]));
                  
                }

                contador_pred++;
                
                chartDataBandaSupBoll_pred.insert(contador_pred, Tuple2(formattedDate,dataLista3[widget.tickEmpresa]['banda sup boll'][a.toString()]));       
              }
              

            break;
            case "MACD":
              int contador = 0;
              int a = 14;
              int quantidade_elementos = (dataLista2[widget.tickEmpresa]['macd'].length)+a;

              
              for (a; a < quantidade_elementos; a++) {
                String label = dataLista[widget.tickEmpresa]['Data'][a.toString()];
                
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
                
                chartDataMACD.insert(contador, Tuple2(formattedDate, dataLista2[widget.tickEmpresa]['macd'][a.toString()]));
                contador++;
              }
              quantidade_elementos = quantidade_elementos + 14;
              int contador_pred = 0;
              //print(quantidade_elementos);
              //print(a);
             
             for (a; a < quantidade_elementos; a++) {
                //print(a);
                String label = dataLista1[widget.tickEmpresa]['data'][a.toString()];
                DateTime parsedDate = DateTime.parse(label);
                String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

                if(contador_pred == 0){
                  
                  chartDataMACD_pred.insert(contador_pred, chartDataMACD[a-15]);
                }

                contador_pred++;
                
                chartDataMACD_pred.insert(contador_pred, Tuple2(formattedDate,dataLista3[widget.tickEmpresa]['macd'][a.toString()]));       
              }
            break;

          }
            


      }

      

    
    } catch (e) {
      
      setState(() {
        hasError = true;
      });
      print('Erro ao carregar os dados: $e');
    }
    
    setState(() {});
 
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enableDoubleTapZooming: true,
      enablePinching: true,
      zoomMode: ZoomMode.xy,
      enablePanning: true,
    );
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    _carregarDados();
  }

  @override
  void didUpdateWidget(GraficoLinear oldWidget) {
    chartData = [];
    chartData_pred = [];
    
    chartDataCotacoes = [];
    chartDataCotacoes_pred = [];

    chartDataMediaMovel = [];
    chartDataMediaMovel_pred = [];
    
    chartDataRSI = [];
    chartDataRSI_pred = [];
    
    chartDataBandaSupBoll = [];
    chartDataBandaSupBoll_pred = [];
    
    chartDataBandaInfBoll = [];
    chartDataBandaInfBoll_pred = [];
    
    chartDataMACD = [];
    chartDataMACD_pred = [];

    name1 = "";
    name2 = "";

    name3 = "";
    name4 = "";
    name5 = "";
    name6 = "";

    super.didUpdateWidget(oldWidget);

    if (oldWidget.tickEmpresa != widget.tickEmpresa || oldWidget.tickEmpresa == widget.tickEmpresa){
      //print(widget.tickEmpresa);
    }
    if (oldWidget.indicator != widget.indicator || oldWidget.indicator == widget.indicator ) {
      
      if(widget.tipoGrafico == 'Price' && oldWidget.tipoGrafico == 'Finanças'){
        widget.indicator = 'Média Móvel 14';
      }
      else if (widget.tipoGrafico == 'Finanças' && oldWidget.tipoGrafico == 'Price'){
        widget.indicator = 'Patrimônio Líquido';
      }
      
     

      _carregarDados();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.tipoGrafico == 'Finanças'){
      return Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
                    child: SfCartesianChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        alignment: ChartAlignment.center,
      ),
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        LineSeries<Tuple3<int, String, double>, String>(
          dataSource: chartData,
          xValueMapper: (Tuple3<int, String, double> spot, _) =>
              spot.item2.toString(),
          yValueMapper: (Tuple3<int, String, double> spot, _) =>
              spot.item3.toDouble(),
          color: Colors.blue,
          name: "$name1",
        ),
        LineSeries<Tuple3<int, String, double>, String>(
          dataSource: chartData_pred,
          xValueMapper: (Tuple3<int, String, double> spot, _) =>
              spot.item2.toString(),
          yValueMapper: (Tuple3<int, String, double> spot, _) =>
              spot.item3.toDouble(),
          color: Colors.red,
          name: "$name2",
        ),
      ],
      zoomPanBehavior: _zoomPanBehavior,
    )))));
    
    }
    else if(widget.indicator == "Média Móvel 14"){
      return Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
                    child: SfCartesianChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        alignment: ChartAlignment.center,
      ),
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        FastLineSeries<Tuple2< String, double>, String>(
          dataSource: chartDataCotacoes,
          animationDelay: 500,
          animationDuration: 3000,
          xValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.blue,
          name: "$name1",
        ),
        FastLineSeries<Tuple2<String, double>, String>(
          dataSource: chartDataCotacoes_pred,
          animationDelay: 500,
          animationDuration: 3000,
          xValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.red,
          name: "$name2",
        ),
        FastLineSeries<Tuple2<String, double>, String>(
          dataSource: chartDataMediaMovel,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Color.fromARGB(255, 255, 124, 2),
          name: "$name3",
        ),
        FastLineSeries<Tuple2<String, double>, String>(
          dataSource: chartDataMediaMovel_pred,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Color.fromARGB(255, 65, 0, 0),
          name: "$name4",
        ),
        ],
      zoomPanBehavior: _zoomPanBehavior,
      ))))


      );
    }
    else if(widget.indicator == 'RSI'){
      return Scaffold( body: SafeArea(
            child: Center(
                child: Container(
                    child: SfCartesianChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        alignment: ChartAlignment.center,
      ),
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        FastLineSeries<Tuple2<String, double>, String>(
          dataSource: chartDataRSI,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.blue,
          name: "$name1",
        ),
        FastLineSeries<Tuple2<String, double>, String>(
          dataSource: chartDataRSI_pred,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.red,
          name: "$name2",
        )
        
       
        ],
      zoomPanBehavior: _zoomPanBehavior,
      ))))


      );
    }

    else if(widget.indicator == "Bollinger Bands"){
      return Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
                    child: SfCartesianChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        alignment: ChartAlignment.center,
      ),
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        FastLineSeries<Tuple2< String, double>, String>(
          dataSource: chartDataCotacoes,
          animationDelay: 500,
          animationDuration: 3000,
          xValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.blue,
          name: "$name1",
        ),
        FastLineSeries<Tuple2< String, double>, String>(
          dataSource: chartDataCotacoes_pred,
          animationDelay: 500,
          animationDuration: 3000,
          
          xValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.red,
          name: "$name2",
        ),
        FastLineSeries<Tuple2<String, double>, String>(
          dataSource: chartDataBandaInfBoll,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.purple,
          name: "$name3",
        ),
        FastLineSeries<Tuple2< String, double>, String>(
          dataSource: chartDataBandaSupBoll,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.purple,
          name: "$name5",
        ),
        FastLineSeries<Tuple2< String, double>, String>(
          dataSource: chartDataBandaInfBoll_pred,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item2.toDouble(),
          color: const Color.fromARGB(255, 51, 1, 59),
          name: "$name4",
        ),
        FastLineSeries<Tuple2< String, double>, String>(
          dataSource: chartDataBandaSupBoll_pred,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item2.toDouble(),
          color: const Color.fromARGB(255, 51, 1, 59),
          name: "$name6",
        ),
        
        ],
      zoomPanBehavior: _zoomPanBehavior,
      ))))


      );

    }
    else if(widget.indicator == "MACD"){
      return Scaffold( body: SafeArea(
            child: Center(
                child: Container(
                    child: SfCartesianChart(
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        alignment: ChartAlignment.center,
      ),
      primaryXAxis: CategoryAxis(
        labelRotation: 45,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
      ),
      tooltipBehavior: _tooltipBehavior,
      series: <ChartSeries>[
        FastLineSeries<Tuple2<String, double>, String>(
          dataSource: chartDataMACD,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.blue,
          name: "$name1",
        ),
        FastLineSeries<Tuple2< String, double>, String>(
          dataSource: chartDataMACD_pred,
          animationDelay: 100,
          animationDuration: 5000,
          xValueMapper: (Tuple2<String, double> spot, _) =>
              spot.item1.toString(),
          yValueMapper: (Tuple2< String, double> spot, _) =>
              spot.item2.toDouble(),
          color: Colors.red,
          name: "$name2",
        )
        
       
        ],
      zoomPanBehavior: _zoomPanBehavior,
      ))))


      );
    }
    
    else{// Grafico de Price
    return Scaffold();
     
    }
    
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
