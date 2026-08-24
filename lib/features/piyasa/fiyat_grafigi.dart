import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../shared/tema.dart';

/// Listede satır sonundaki küçük eğri. Eksen yok, etiket yok: tek işi
/// yönü göstermek.
class MiniGrafik extends StatelessWidget {
  const MiniGrafik({super.key, required this.seri});

  final List<double> seri;

  @override
  Widget build(BuildContext context) {
    if (seri.length < 2) return const SizedBox();
    final tema = Theme.of(context);
    final artiyor = seri.last >= seri.first;
    final renk = artiyor ? tema.oyun.kazanc : tema.oyun.kayip;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        minY: seri.reduce((a, b) => a < b ? a : b),
        maxY: seri.reduce((a, b) => a > b ? a : b),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < seri.length; i++)
                FlSpot(i.toDouble(), seri[i]),
            ],
            isCurved: true,
            barWidth: 1.6,
            color: renk,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

/// Detay kâğıdındaki reel fiyat grafiği.
///
/// Y ekseninde etiket YOK. Reel fiyatın mutlak değeri oyuncuya bir şey
/// söylemiyor (100 puanlık mevduat endeksi ile 3,5 milyonluk daire aynı
/// eksende okunmaz); anlamlı olan eğrinin şekli ve başlıktaki yüzde.
class FiyatGrafigi extends StatelessWidget {
  const FiyatGrafigi({super.key, required this.seri});

  final List<double> seri;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    if (seri.length < 2) return const SizedBox(height: 8);

    final enAz = seri.reduce((a, b) => a < b ? a : b);
    final enCok = seri.reduce((a, b) => a > b ? a : b);
    // Düz seride (mevduat) min == max olabilir; sıfır yükseklik çizilemez.
    final pay = (enCok - enAz).abs() < 1e-9 ? enCok.abs() * 0.1 + 1 : 0.0;
    final renk = seri.last >= seri.first ? tema.oyun.kazanc : tema.oyun.kayip;

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: tema.colorScheme.outlineVariant,
              strokeWidth: 0.5,
            ),
          ),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minY: enAz - pay,
          maxY: enCok + pay,
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < seri.length; i++)
                  FlSpot(i.toDouble(), seri[i]),
              ],
              isCurved: true,
              barWidth: 2,
              color: renk,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: renk.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
