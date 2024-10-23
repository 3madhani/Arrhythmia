import 'package:arrhythmia/chatpapp/service/firebase_firestore_service.dart';
import 'package:arrhythmia/chatpapp/view/screens/chat_screen.dart';
import 'package:arrhythmia/chatpapp/view/screens/search_screen.dart';
import 'package:arrhythmia/models/Doctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Doctor profile page to display detailed information about a doctor
class DoctorProfilePage extends StatefulWidget {
  final Doctor doctor;

  const DoctorProfilePage({super.key, required this.doctor});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF95C55),
        title: const Text(
          'Doctor Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.doctor.photoUrl),
            ),
            const SizedBox(height: 20),
            Text(
              widget.doctor.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.doctor.specialty,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              widget.doctor.bio,
              maxLines: 3,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 5),
            RatingBar.builder(
              initialRating: widget.doctor.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  FirebaseFirestoreService.updateUserData({
                    'rating': rating,
                  }, widget.doctor.uid);
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  const Color(0xFFF95C55),
                ),
                foregroundColor: WidgetStateProperty.all<Color>(
                  Colors.white,
                ),
                fixedSize: const WidgetStatePropertyAll(Size(200, 50)),
              ),
              onPressed: () {
                FirebaseFirestoreService.createRoom(widget.doctor.uid);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ChatScreen(userId: widget.doctor.uid),
                )); // Navigate to chat page
              },
              child: const Text(
                'Chat with Doctor',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Doctor list page displaying a grid of doctor profiles
class DoctorListPage extends StatelessWidget {
  final List<Doctor> doctors;

  const DoctorListPage({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF95C55),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Doctor List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const UsersSearchScreen()),
              ),
              icon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 35,
              ),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DoctorProfilePage(doctor: doctors[index]),
                ),
              );
            },
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(doctors[index].photoUrl),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    doctors[index].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    doctors[index].specialty,
                  ),
                  const SizedBox(height: 5),
                  RatingBarIndicator(
                    rating: doctors[index].rating,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20,
                    unratedColor: Colors.grey[400],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyDoctors extends StatelessWidget {
  const MyDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    // Doctor doctors;
    // = [
    //   // Doctor(
    //   //   name: 'Dr. John Doe',
    //   //   photoUrl: 'https://via.placeholder.com/150',
    //   //   specialty: 'Cardiologist',
    //   //   rating: 4.5,
    //   //   bio: 'is a highly experienced cardiologist...',
    //   // ),
    //   // Doctor(
    //   //   name: 'Dr. Jane Smith',
    //   //   photoUrl: 'https://via.placeholder.com/150',
    //   //   specialty: 'Cardiologist',
    //   //   rating: 4.2,
    //   //   bio: 'is a cardiologist in diagnostic cardic dieases',
    //   // ),
    //   // Doctor(
    //   //   name: 'Dr. Alex Johnson',
    //   //   photoUrl: 'https://via.placeholder.com/150',
    //   //   specialty: 'Cardiologist',
    //   //   rating: 4.8,
    //   //   bio: 'is a cardiologist diagnostic cardic dieases',
    //   // ),
    //   // Doctor(
    //   //   name: 'Dr. Ahmed Ali',
    //   //   photoUrl: 'https://via.placeholder.com/150',
    //   //   specialty: 'Cardiologist',
    //   //   rating: 3.5,
    //   //   bio: 'is a meduim experienced cardiologist...',
    //   // ),
    //   // Doctor(
    //   //   name: 'Dr. Mohammed Ahmed',
    //   //   photoUrl: 'https://via.placeholder.com/150',
    //   //   specialty: 'Cardiologist',
    //   //   rating: 2.5,
    //   //   bio: 'is a caradologist specially in heart failure',
    //   // ),
    //   // Doctor(
    //   //   name: 'Dr. Manal Adel',
    //   //   photoUrl: 'https://via.placeholder.com/150',
    //   //   specialty: 'Cardiologist',
    //   //   rating: 4,
    //   //   bio: 'is a caradologist specially in heart failure',
    //   // ),
    //   // Doctor(
    //   //   name: 'Dr. Youmna Ali',
    //   //   photoUrl: 'https://via.placeholder.com/150',
    //   //   specialty: 'Cardiologist',
    //   //   rating: 4.8,
    //   //   bio: 'is a caradologist specially in Arrhythmia detection',
    //   // ),
    //   // Doctor(
    //   //   name: 'Dr. Mohammed Alaa',
    //   //   photoUrl: 'https://via.placeholder.com/150',
    //   //   specialty: 'Cardiologist',
    //   //   rating: 2,
    //   //   bio: 'is a caradologist specially in heart surgery',
    //   // ),
    // ];

    // Sort doctors in descending order based on their rating
    // doctors.sort((a, b) => b.rating.compareTo(a.rating));
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("userType", isEqualTo: "doctor")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Doctor> doctors = snapshot.data!.docs.map((snapshot) {
              return Doctor(
                bio: snapshot['bio'],
                name: snapshot['name'],
                photoUrl: snapshot['image'],
                specialty: snapshot['specialty'],
                rating: snapshot['rating'],
                uid: snapshot['uid'],
              );
            }).toList();
            return DoctorListPage(doctors: doctors);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
