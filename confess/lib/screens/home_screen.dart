import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Logout", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to logout?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text("Logout"),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  void _likePost(String docId, int currentLikes) {
    FirebaseFirestore.instance.collection('confessions').doc(docId).update({
      'likes': currentLikes + 1,
    });
  }

  void _flagPost(String docId, int currentFlags) {
    FirebaseFirestore.instance.collection('confessions').doc(docId).update({
      'flags': currentFlags + 1,
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F23), // Deep space black-blue
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1E36),
        title: const Text('Confession Wall'),
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.purpleAccent.withOpacity(0.3),
        actions: [
          if (currentUser != null && currentUser.email == 'admin@confess.com')
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.cyanAccent),
              onPressed: () => Navigator.of(context).pushNamed('/moderator'),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('confessions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.purpleAccent));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text("No confessions yet.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (ctx, index) {
              final data = docs[index];
              if (data['flags'] >= 3) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['text'],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeago.format(data['timestamp'].toDate()),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up, color: Colors.greenAccent),
                                onPressed: () => _likePost(data.id, data['likes']),
                              ),
                              Text('${data['likes']}', style: const TextStyle(color: Colors.white)),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.flag, color: Colors.redAccent),
                                onPressed: () => _flagPost(data.id, data['flags']),
                              ),
                              Text('${data['flags']}', style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purpleAccent,
        icon: const Icon(Icons.add),
        label: const Text("Post Confession"),
        onPressed: () => Navigator.of(context).pushNamed('/post'),
      ),
    );
  }
}