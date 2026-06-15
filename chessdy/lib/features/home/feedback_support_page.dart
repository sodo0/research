import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';

class FeedbackSupportPage extends StatelessWidget {
  const FeedbackSupportPage({super.key});

  Future<void> _copyEmail() async {
    await Clipboard.setData(const ClipboardData(text: 'support@chessdy.com'));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.feedbackAndSupport)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Email Support
          Card(
            child: ListTile(
              leading: const Icon(Icons.email, color: Colors.teal),
              title: Text(
                l10n.emailSupport,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('support@chessdy.com'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.emailSupport),
                    content: Text(
                      l10n.emailSupportDesc,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _copyEmail();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.emailCopied)),
                          );
                        },
                        child: Text(l10n.copyEmail),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Leave a Review
          Card(
            child: ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: Text(
                l10n.leaveReview,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(l10n.rateOnStore),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.leaveReview),
                    content: Text(l10n.leaveReviewDesc),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.maybeLater),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.openingAppStore),
                            ),
                          );
                          // In production: launch app store URL
                        },
                        child: Text(l10n.rateNow),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Feedback Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.sendFeedback,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: l10n.yourEmail,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: l10n.feedback,
                      border: const OutlineInputBorder(),
                      hintText: l10n.tellUsWhatYouThink,
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.thankYouFeedback),
                          ),
                        );
                      },
                      child: Text(l10n.sendFeedback),
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
}

