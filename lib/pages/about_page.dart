import 'package:flutter/material.dart';

class OurTeamPage extends StatelessWidget {
  const OurTeamPage({Key? key}) : super(key: key);

  final List<TeamMember> members = const [
    TeamMember(
      name: 'Rayssa Modelline .J.S',
      id: '2310511151',
      imagePath: 'assets/rayssa.png',
    ),
    TeamMember(
      name: 'Muhamad Najwan',
      id: '2310511149',
      imagePath: 'assets/muhamad.png',
    ),
    TeamMember(
      name: 'Abdul Faris Aufar',
      id: '2310511154',
      imagePath: 'assets/abdul.png',
    ),
    TeamMember(
      name: 'Daniel Hemas .M.S',
      id: '2310511162',
      imagePath: 'assets/daniel.jpg',
    ),
    TeamMember(
      name: 'Aqiel Syafiq Rahman',
      id: '2310511139',
      imagePath: 'assets/aqiel.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.grey[800],
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'OUR TEAM',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'This Is Our Team.',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: members.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6), // Tailwind gray-100
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        SquareTile(
                          imagePath: member.imagePath,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2E3A59),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                member.id,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String id;
  final String imagePath;

  const TeamMember({
    required this.name,
    required this.id,
    required this.imagePath,
  });
}

class SquareTile extends StatelessWidget {
  final String imagePath;

  const SquareTile({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}
