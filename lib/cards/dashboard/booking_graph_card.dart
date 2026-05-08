import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../theme/app_theme.dart';

class BookingGraphCard extends StatelessWidget {
  final List<double> data;

  const BookingGraphCard({super.key, required this.data});

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
                  Text('Booking Analytics', style: AppTextStyles.cardTitle),
                  Text('Monthly booking trends for 2024', style: AppTextStyles.caption),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(IconsaxPlusLinear.graph, color: AppColors.primaryAccent, size: 20),
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
                      interval: 20,
                      getTitlesWidget: _leftTitleWidgets,
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 120,
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                    isCurved: true,
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryAccent]),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withAlpha(30),
                          AppColors.primary.withAlpha(0),
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
      case 2: text = const Text('MAR', style: style); break;
      case 4: text = const Text('MAY', style: style); break;
      case 6: text = const Text('JUL', style: style); break;
      case 8: text = const Text('SEP', style: style); break;
      case 10: text = const Text('NOV', style: style); break;
      default: text = const Text('', style: style); break;
    }
    return SideTitleWidget(meta: meta, child: text);
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(color: AppColors.textTertiary, fontWeight: FontWeight.bold, fontSize: 10, fontFamily: 'Lexend');
    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(value.toInt().toString(), style: style),
    );
  }
}
