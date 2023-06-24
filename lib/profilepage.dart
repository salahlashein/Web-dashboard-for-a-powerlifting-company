import 'package:flutter/material.dart';
import 'package:web_dashboard/models/Athlete.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  final Athlete athlete;

  const ProfilePage({super.key, required this.athlete});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileWidget(
                imagePath: widget.athlete.imagePath,
              ),
              const SizedBox(height: 24),
              buildName(widget.athlete),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Edit Profile'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                              athlete: widget.athlete,
                            )),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildButton(context, widget.athlete.bench, 'Bench'),
                  buildDivider(),
                  buildButton(context, widget.athlete.deadlift, 'Deadlift'),
                  buildDivider(),
                  buildButton(context, widget.athlete.squat, 'Squat'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(color: Colors.white),
      );
  Widget buildName(Athlete athlete) => Column(
        children: [
          Text(
            athlete.firstName + ' ' + athlete.lastName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            athlete.email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: () {}),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

////////////////// Edit Profile ////////////////////////////
class EditProfilePage extends StatefulWidget {
  final Athlete athlete;

  const EditProfilePage({super.key, required this.athlete});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileWidget(
                imagePath: widget.athlete.imagePath,
                isEdit: true,
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'Full Name',
                text: widget.athlete.firstName + ' ' + widget.athlete.lastName,
                onChanged: (name) {},
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'Email',
                text: 'user.email',
                onChanged: (email) {},
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: 'About',
                text: 'user.about',
                maxLines: 5,
                onChanged: (about) {},
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
}

class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    this.maxLines = 1,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: widget.maxLines,
          ),
        ],
      );
}

Widget buildButton(BuildContext context, String value, String text) =>
    MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 4),
      onPressed: () {},
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
          SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
