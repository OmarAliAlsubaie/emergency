import '../../../models/scenario.dart';
import '../../../models/scenario_step.dart';
import '../../../models/scenario_option.dart';

class ScenarioBuilder {
  static Scenario build5StationScenario({
    required String id,
    required String categoryId,
    required String titleAr,
    required String titleEn,
    required String descriptionAr,
    required String descriptionEn,
    required String difficulty,
    required String icon,
    required int colorHex,
    required List<Map<String, String>> stations,
  }) {
    assert(stations.length == 5, 'Every scenario must have exactly 5 stations');

    return Scenario(
      id: id,
      categoryId: categoryId,
      titleAr: titleAr.contains('5 محطات') ? titleAr : '$titleAr - 5 محطات',
      titleEn: titleEn.contains('5 Stations') ? titleEn : '$titleEn - 5 Stations',
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      difficulty: difficulty,
      timeLimitSeconds: 30,
      icon: icon,
      colorHex: colorHex,
      steps: List.generate(stations.length, (index) {
        final s = stations[index];
        final stepOrder = index + 1;
        final stepId = 'step_${id}_$stepOrder';
        return ScenarioStep(
          id: stepId,
          scenarioId: id,
          stepOrder: stepOrder,
          situationAr: s['sitAr']!.startsWith('المحطة') ? s['sitAr']! : 'المحطة $stepOrder: ${s['sitAr']}',
          situationEn: s['sitEn']!.startsWith('Station') ? s['sitEn']! : 'Station $stepOrder: ${s['sitEn']}',
          visualTheme: categoryId,
          hintAr: s['hintAr']!,
          hintEn: s['hintEn']!,
          options: [
            ScenarioOption(
              id: 'opt_${id}_${stepOrder}_a',
              stepId: stepId,
              textAr: s['safeTextAr']!,
              textEn: s['safeTextEn']!,
              isSafe: true,
              speedScore: 25,
              xpReward: stepOrder == 5 ? 35 : 30,
              safetyScore: 100,
              explanationAr: s['safeExpAr']!,
              explanationEn: s['safeExpEn']!,
              outcomeSummaryAr: s['safeOutAr']!,
              outcomeSummaryEn: s['safeOutEn']!,
            ),
            ScenarioOption(
              id: 'opt_${id}_${stepOrder}_b',
              stepId: stepId,
              textAr: s['unsafeTextAr']!,
              textEn: s['unsafeTextEn']!,
              isSafe: false,
              speedScore: 0,
              xpReward: 0,
              safetyScore: 0,
              explanationAr: s['unsafeExpAr']!,
              explanationEn: s['unsafeExpEn']!,
              outcomeSummaryAr: s['unsafeOutAr']!,
              outcomeSummaryEn: s['unsafeOutEn']!,
            ),
          ],
        );
      }),
    );
  }
}
