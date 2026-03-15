import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/locale_controller.dart';
import '../l10n/app_localizations.dart';
import '../services/sales_refresh_notifier.dart';
import '../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  final LocaleController localeController;

  const SettingsPage({super.key, required this.localeController});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  final chickenLargePriceController = TextEditingController();
  final chickenSmallPriceController = TextEditingController();
  final lumpiaPriceController = TextEditingController();
  final ricePriceController = TextEditingController();

  bool isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final settings = await SettingsService.getSettings();

    if (!mounted) return;

    chickenLargePriceController.text = settings.chickenLargePrice.toString();
    chickenSmallPriceController.text = settings.chickenSmallPrice.toString();
    lumpiaPriceController.text = settings.lumpiaPrice.toString();
    ricePriceController.text = settings.ricePrice.toString();

    setState(() {
      isLoading = false;
    });
  }

  int parseValue(TextEditingController controller, int fallback) {
    final value = int.tryParse(controller.text.trim());
    if (value == null || value < 0) return fallback;
    return value;
  }

  Future<void> changeLanguage(String languageCode) async {
    await widget.localeController.setLocale(Locale(languageCode));

    if (!mounted) return;

    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.settingsLanguageSaved),
        backgroundColor: const Color(0xFFF59E0B),
      ),
    );
  }

  Future<void> saveSettings() async {
    final settings = AppSettings(
      chickenLargePrice: parseValue(
        chickenLargePriceController,
        SettingsService.defaultChickenLargePrice,
      ),
      chickenSmallPrice: parseValue(
        chickenSmallPriceController,
        SettingsService.defaultChickenSmallPrice,
      ),
      lumpiaPrice: parseValue(
        lumpiaPriceController,
        SettingsService.defaultLumpiaPrice,
      ),
      ricePrice: parseValue(
        ricePriceController,
        SettingsService.defaultRicePrice,
      ),
    );

    await SettingsService.saveSettings(settings);
    SalesRefreshNotifier.notifyRefresh();

    if (!mounted) return;

    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.settingsSavedSuccessfully),
        backgroundColor: const Color(0xFFF59E0B),
      ),
    );
  }

  Future<void> resetDefaults() async {
    final defaultSettings = const AppSettings(
      chickenLargePrice: SettingsService.defaultChickenLargePrice,
      chickenSmallPrice: SettingsService.defaultChickenSmallPrice,
      lumpiaPrice: SettingsService.defaultLumpiaPrice,
      ricePrice: SettingsService.defaultRicePrice,
    );

    await SettingsService.saveSettings(defaultSettings);
    SalesRefreshNotifier.notifyRefresh();

    if (!mounted) return;

    chickenLargePriceController.text = SettingsService.defaultChickenLargePrice
        .toString();
    chickenSmallPriceController.text = SettingsService.defaultChickenSmallPrice
        .toString();
    lumpiaPriceController.text = SettingsService.defaultLumpiaPrice.toString();
    ricePriceController.text = SettingsService.defaultRicePrice.toString();

    final l10n = AppLocalizations.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.settingsResetSuccessfully),
        backgroundColor: const Color(0xFFF59E0B),
      ),
    );
  }

  InputDecoration inputDecoration(String label, String helper) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFE6E8EF), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFF59E0B), width: 1.8),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF64748B),
        fontWeight: FontWeight.w600,
      ),
      helperStyle: const TextStyle(color: Color(0xFF94A3B8)),
    );
  }

  Widget numberField({
    required String label,
    required String helper,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: inputDecoration(label, helper),
    );
  }

  Widget sectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget languageOption({
    required String title,
    required String subtitle,
    required String languageCode,
    required IconData icon,
  }) {
    final isSelected =
        widget.localeController.locale.languageCode == languageCode;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => changeLanguage(languageCode),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7ED) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF59E0B)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF59E0B).withAlpha(26)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget heroCard() {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30F59E0B),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.settings_rounded, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            l10n.settingsHeroTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.settingsHeroSubtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    chickenLargePriceController.dispose();
    chickenSmallPriceController.dispose();
    lumpiaPriceController.dispose();
    ricePriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(
          l10n.settingsAppBarTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                heroCard(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: sectionCard(
                    title: l10n.settingsLanguageSectionTitle,
                    subtitle: l10n.settingsLanguageSectionSubtitle,
                    children: [
                      languageOption(
                        title: l10n.settingsLanguageEnglish,
                        subtitle: l10n.settingsLanguageEnglishSubtitle,
                        languageCode: 'en',
                        icon: Icons.language_rounded,
                      ),
                      const SizedBox(height: 12),
                      languageOption(
                        title: l10n.settingsLanguageFilipino,
                        subtitle: l10n.settingsLanguageFilipinoSubtitle,
                        languageCode: 'fil',
                        icon: Icons.translate_rounded,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: sectionCard(
                    title: l10n.settingsProductPricesTitle,
                    subtitle: l10n.settingsProductPricesSubtitle,
                    children: [
                      numberField(
                        label: l10n.settingsChickenLargePrice,
                        helper: l10n.settingsDefaultPrice(
                          '₱${SettingsService.defaultChickenLargePrice}',
                        ),
                        controller: chickenLargePriceController,
                      ),
                      const SizedBox(height: 12),
                      numberField(
                        label: l10n.settingsChickenSmallPrice,
                        helper: l10n.settingsDefaultPrice(
                          '₱${SettingsService.defaultChickenSmallPrice}',
                        ),
                        controller: chickenSmallPriceController,
                      ),
                      const SizedBox(height: 12),
                      numberField(
                        label: l10n.settingsLumpiaPrice,
                        helper: l10n.settingsDefaultPrice(
                          '₱${SettingsService.defaultLumpiaPrice}',
                        ),
                        controller: lumpiaPriceController,
                      ),
                      const SizedBox(height: 12),
                      numberField(
                        label: l10n.settingsRicePrice,
                        helper: l10n.settingsDefaultPrice(
                          '₱${SettingsService.defaultRicePrice}',
                        ),
                        controller: ricePriceController,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: resetDefaults,
                          icon: const Icon(Icons.restart_alt_rounded),
                          label: Text(l10n.settingsResetDefaults),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFFF59E0B)),
                            foregroundColor: const Color(0xFFF59E0B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: saveSettings,
                          icon: const Icon(Icons.save_rounded),
                          label: Text(l10n.settingsSaveSettings),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
