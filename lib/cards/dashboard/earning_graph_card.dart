import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';

class EarningGraphCard extends StatelessWidget {
  final List<double> data;

  const EarningGraphCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Revenue Growth', style: AppTextStyles.cardTitle),
                  Text('Monthly payment collection trends', style: AppTextStyles.caption),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryCyan.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(IconsaxPlusLinear.money_tick, color: AppColors.secondaryCyan, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.divider.withAlpha(50),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: _bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10000,
                      getTitlesWidget: _leftTitleWidgets,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 40000,
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                    isCurved: true,
                    gradient: const LinearGradient(colors: [AppColors.secondaryCyan, AppColors.primaryAccent]),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondaryCyan.withAlpha(30),
                          AppColors.secondaryCyan.withAlpha(0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: AppColors.textTertiary, fontWeight: FontWeight.bold, fontSize: 10, fontFamily: 'Lexend');
    Widget text;
    switch (value.toInt()) {
      case 0: text = const Text('JAN', style: style); break;
      case 3: text = const Text('APR', style: style); break;
      case 6: text = const Text('JUL', style: style); break;
      case 9: text = const Text('OCT', style: style); break;
      case 11: text = const Text('DEC', style: style); break;
      default: text = const Text('', style: style); break;
    }
    return SideTitleWidget(meta: meta, child: text);
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: AppColors.textTertiary, fontWeight: FontWeight.bold, fontSize: 10, fontFamily: 'Lexend');
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${(value / 1000).toInt()}k';
    }
    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(text, style: style),
    );
  }
}
