import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PostConfessionScreen extends StatefulWidget {
  const PostConfessionScreen({super.key});

  @override
  State<PostConfessionScreen> createState() => _PostConfessionScreenState();
}

class _PostConfessionScreenState extends State<PostConfessionScreen> {
  final _confessionController = TextEditingController();
  bool _isPosting = false;

  Future<void> _submitConfession() async {
    final text = _confessionController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isPosting = true);

    try {
      await FirebaseFirestore.instance.collection('confessions').add({
        'id': const Uuid().v4(),
        'text': text,
        'likes': 0,
        'flags': 0,
        'timestamp': Timestamp.now(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Confession posted anonymously!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post confession: $e')),
      );
    } finally {
      setState(() => _isPosting = false);
    }
  }

  @override
  void dispose() {
    _confessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F23),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1E36),
        title: const Text("Post Confession"),
        elevation: 10,
        shadowColor: Colors.purpleAccent.withOpacity(0.4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2D2D54), Color(0xFF191927)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Share your thoughts anonymously',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _confessionController,
                  maxLines: 5,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type your anonymous confession...',
                    hintStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isPosting ? null : _submitConfession,
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: Text(
                      _isPosting ? 'Posting...' : 'Post',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}