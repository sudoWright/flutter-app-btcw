import 'dart:convert';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:wallet/constants/constants.dart';
import 'package:wallet/constants/proton.color.dart';
import 'package:wallet/helper/exchange.caculator.dart';
import 'package:wallet/helper/user.settings.provider.dart';
import 'package:wallet/l10n/generated/locale.dart';
import 'package:wallet/managers/services/exchange.rate.service.dart';
import 'package:wallet/rust/proton_api/exchange_rate.dart';
import 'package:wallet/rust/proton_api/user_settings.dart';
import 'package:wallet/theme/theme.font.dart';

enum BitcoinPriceChartDataRange {
  past1Day,
  past7Days,
  past1Month,
  past6Month,
  past1Year,
}

class BitcoinPriceChart extends StatefulWidget {
  final ProtonExchangeRate exchangeRate;
  final double priceChange;

  const BitcoinPriceChart({
    required this.exchangeRate,
    required this.priceChange,
    super.key,
  });

  @override
  BitcoinPriceChartState createState() => BitcoinPriceChartState();
}

class BitcoinPriceChartState extends State<BitcoinPriceChart> {
  List<FlSpot> dataPoints = [];
  bool isLoading = true;
  double priceChange = 0.0;
  double percentile0 = 0.0;
  double percentile25 = 0.0;
  double percentile100 = 0.0;
  double percentile75 = 0.0;
  String dataRangeString = "1D";
  BitcoinPriceChartDataRange dataRange = BitcoinPriceChartDataRange.past1Day;
  List<BitcoinPriceChartDataRange> dataRangeOptions = [
    BitcoinPriceChartDataRange.past1Day,
    BitcoinPriceChartDataRange.past7Days,
    BitcoinPriceChartDataRange.past1Month,
    BitcoinPriceChartDataRange.past6Month,
    BitcoinPriceChartDataRange.past1Year,
  ];

  @override
  void didUpdateWidget(BitcoinPriceChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exchangeRate.fiatCurrency !=
        widget.exchangeRate.fiatCurrency) {
      setState(fetchData);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    Response? response;
    switch (dataRange) {
      case BitcoinPriceChartDataRange.past1Day:
        dataRangeString = "1D";
        response = await http.get(Uri.parse(
            'https://api.binance.com/api/v1/klines?symbol=BTCUSDT&interval=1h&limit=24'));
      case BitcoinPriceChartDataRange.past7Days:
        dataRangeString = "7D";
        response = await http.get(Uri.parse(
            'https://api.binance.com/api/v1/klines?symbol=BTCUSDT&interval=1h&limit=168'));
      case BitcoinPriceChartDataRange.past1Month:
        dataRangeString = "1M";
        response = await http.get(Uri.parse(
            'https://api.binance.com/api/v1/klines?symbol=BTCUSDT&interval=1d&limit=30'));
      case BitcoinPriceChartDataRange.past6Month:
        dataRangeString = "6M";
        response = await http.get(Uri.parse(
            'https://api.binance.com/api/v1/klines?symbol=BTCUSDT&interval=1d&limit=180'));
      case BitcoinPriceChartDataRange.past1Year:
        dataRangeString = "1Y";
        response = await http.get(Uri.parse(
            'https://api.binance.com/api/v1/klines?symbol=BTCUSDT&interval=1d&limit=365'));
    }
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      final List<FlSpot> spots = [];
      int index = 0;

      // TODO(feng): fix logic here
      double rate2Fiat = 1.0;
      const int amountInSatoshi = 10000;
      if (widget.exchangeRate.fiatCurrency != FiatCurrency.usd) {
        final ProtonExchangeRate exchangeRateInUSD =
            await ExchangeRateService.getExchangeRate(FiatCurrency.usd);
        rate2Fiat = ExchangeCalculator.getNotionalInFiatCurrency(
                widget.exchangeRate, amountInSatoshi) /
            ExchangeCalculator.getNotionalInFiatCurrency(
                exchangeRateInUSD, amountInSatoshi);
      }
      final List<double> values = [];
      for (var data in json) {
        final double bitcoinNotionalInFiat = double.parse(data[4]) * rate2Fiat;
        spots.add(FlSpot(
          index.toDouble(),
          double.parse(bitcoinNotionalInFiat.toStringAsFixed(2)),
        ));
        values.add(bitcoinNotionalInFiat);
        index++;
      }

      if (mounted) {
        setState(() {
          dataPoints = spots;
          isLoading = false;
          priceChange = (values.last - values.first) / values.last * 100;
          if (values.isNotEmpty) {
            values.sort();
            percentile25 = values[(values.length * 0.25).floor()];
            percentile0 = values[(values.length * 0.0).floor()];
            percentile75 = values[(values.length * 0.75).floor()];
            percentile100 = values[values.length - 1];
          }
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget buildChart(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Column(children: [
        const SizedBox(
          height: 6,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          height: 140,
          child: Center(
            child: isLoading
                ? CircularProgressIndicator(color: ProtonColors.protonBlue)
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: dataPoints,
                            dotData: const FlDotData(
                              show: false,
                            ),
                            color: priceChange >= 0
                                ? ProtonColors.signalSuccess
                                : ProtonColors.signalError,
                          ),
                        ],
                        borderData: FlBorderData(
                          show: false,
                          // border: Border(
                          //   left: BorderSide(
                          //     width: 1.0,
                          //     color: ProtonColors.textWeak,
                          //   ),
                          // ),
                        ),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: ProtonColors.white,
                              tooltipBorder: BorderSide(
                                color: ProtonColors.textWeak,
                              )),
                        ),
                        gridData: const FlGridData(
                          drawVerticalLine: false,
                          drawHorizontalLine: false,
                        ),
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: percentile0,
                              dashArray: [5, 5],
                              color: ProtonColors.textHint,
                              strokeWidth: 0.4,
                              label: HorizontalLineLabel(
                                alignment: Alignment.topRight,
                              ),
                            ),
                            HorizontalLine(
                              y: percentile100,
                              dashArray: [5, 5],
                              color: ProtonColors.textHint,
                              strokeWidth: 0.4,
                              label: HorizontalLineLabel(
                                alignment: Alignment.topRight,
                              ),
                            ),
                          ],
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, titleMeta) {
                              if (percentile0.ceil() == value.ceil()) {
                                return Text(
                                  percentile0.toStringAsFixed(0),
                                  style: FontManager.captionRegular(
                                    ProtonColors.textWeak,
                                  ),
                                );
                              }
                              if (percentile100.ceil() == value.ceil()) {
                                return Text(
                                  percentile100.toStringAsFixed(0),
                                  style: FontManager.captionRegular(
                                    ProtonColors.textWeak,
                                  ),
                                );
                              }
                              if (percentile25.ceil() == value.ceil()) {
                                return Text(
                                  percentile25.toStringAsFixed(0),
                                  style: FontManager.captionRegular(
                                    ProtonColors.textWeak,
                                  ),
                                );
                              }
                              if (percentile75.ceil() == value.ceil()) {
                                return Text(
                                  percentile75.toStringAsFixed(0),
                                  style: FontManager.captionRegular(
                                    ProtonColors.textWeak,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                            reservedSize: 50,
                          )),
                          bottomTitles: const AxisTitles(),
                          rightTitles: const AxisTitles(),
                          topTitles: const AxisTitles(),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: Center(
            child: ChipsChoice<BitcoinPriceChartDataRange>.single(
              value: dataRange,
              onChanged: (val) => setState(() {
                if (val != dataRange) {
                  dataRange = val;
                  fetchData();
                }
              }),
              choiceItems:
                  C2Choice.listFrom<BitcoinPriceChartDataRange, String>(
                source: ["1D", "7D", "1M", "6M", "1Y"],
                value: (i, v) => dataRangeOptions[i],
                label: (i, v) => v,
                tooltip: (i, v) => v,
              ),
              padding: EdgeInsets.zero,
              choiceStyle: C2ChipStyle.filled(
                selectedStyle: C2ChipStyle(
                  backgroundColor: ProtonColors.textHint,
                  foregroundStyle: FontManager.body2Regular(
                    ProtonColors.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                ),
                color: ProtonColors.white,
                foregroundStyle: FontManager.body2Regular(
                  ProtonColors.textNorm,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        S.of(context).btc_price,
        style: FontManager.body2Regular(ProtonColors.textHint),
        textAlign: TextAlign.left,
      ),
      const SizedBox(
        height: 2,
      ),
      AnimatedFlipCounter(
          duration: const Duration(milliseconds: 500),
          thousandSeparator: ",",
          prefix: Provider.of<UserSettingProvider>(
            context,
            listen: false,
          ).getFiatCurrencySign(fiatCurrency: widget.exchangeRate.fiatCurrency),
          value: ExchangeCalculator.getNotionalInFiatCurrency(
              widget.exchangeRate, 100000000),
          // value: price,
          fractionDigits: defaultDisplayDigits,
          textStyle: FontManager.titleHeadline(ProtonColors.textNorm)),
      const SizedBox(
        height: 2,
      ),
      priceChange > 0
          ? AnimatedFlipCounter(
              duration: const Duration(milliseconds: 500),
              prefix: "+",
              value: priceChange,
              suffix: "% ($dataRangeString)",
              fractionDigits: 2,
              textStyle: FontManager.body2Regular(ProtonColors.signalSuccess))
          : AnimatedFlipCounter(
              duration: const Duration(milliseconds: 500),
              prefix: "",
              value: priceChange,
              suffix: "% ($dataRangeString)",
              fractionDigits: 2,
              textStyle: FontManager.body2Regular(ProtonColors.signalError)),
      const SizedBox(
        height: 8,
      ),
      buildChart(context),
      const SizedBox(
        height: 8,
      ),
    ]);
  }
}
