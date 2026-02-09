import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const _FAQItem(
            question: 'How do I place an order?',
            answer: 'Browse through our products, add items to your cart, and proceed to checkout. You can pay using M-Pesa for a quick and secure transaction.',
          ),
          const _FAQItem(
            question: 'What payment methods do you accept?',
            answer: 'We currently accept M-Pesa payments. Simply enter your phone number at checkout and you\'ll receive a prompt to complete the payment.',
          ),
          const _FAQItem(
            question: 'How long does delivery take?',
            answer: 'Delivery typically takes 1-3 business days depending on your location. You can track your order status in the Orders tab.',
          ),
          const _FAQItem(
            question: 'Can I cancel my order?',
            answer: 'Yes, you can cancel your order before it\'s processed. Once it\'s out for delivery, cancellation may not be possible.',
          ),
          const _FAQItem(
            question: 'What if I receive a damaged product?',
            answer: 'If you receive a damaged product, please contact our support team immediately with photos of the damaged item. We\'ll arrange a replacement or refund.',
          ),
          const _FAQItem(
            question: 'How do I track my order?',
            answer: 'You can track your order status in the Orders tab. You\'ll see real-time updates as your order moves from pending to processing to delivered.',
          ),
          const SizedBox(height: 24),
          Text(
            'Contact Us',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Email'),
                    subtitle: const Text('support@globeapp.com'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.phone_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Phone'),
                    subtitle: const Text('+254 700 123 456'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Working Hours'),
                    subtitle: const Text('Monday - Saturday: 8:00 AM - 6:00 PM'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Open chat support
              },
              icon: const Icon(Icons.chat_outlined),
              label: const Text('Chat with Support'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  widget.answer,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}