
import 'package:flutter/material.dart';
import 'package:ruet_cse_management/model/routine_model.dart';
import 'package:ruet_cse_management/screens/home_drawer.dart';

class first_saturday_routine extends StatelessWidget {
  const first_saturday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Year Saturday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const first_year_drawer(),
      body: routine_model('first year', 'saturday'),
    );
  }
}

class first_sunday_routine extends StatelessWidget {
  const first_sunday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Year Sunday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const first_year_drawer(),
      body: routine_model('first year', 'sunday'),
    );
  }
}

class first_monday_routine extends StatelessWidget {
  const first_monday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Year Monday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const first_year_drawer(),
      body: routine_model('first year', 'monday'),
    );
  }
}

class first_tuesday_routine extends StatelessWidget {
  const first_tuesday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Year Tuesday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const first_year_drawer(),
      body: routine_model('first year', 'tuesday'),
    );
  }
}

class first_wednesday_routine extends StatelessWidget {
  const first_wednesday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Year Wednesday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const first_year_drawer(),
      body: routine_model('first year', 'wednesday'),
    );
  }
}

class second_saturday_routine extends StatelessWidget {
  const second_saturday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Year Saturday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const second_year_drawer(),
      body: routine_model('second year', 'saturday'),
    );
  }
}

class second_sunday_routine extends StatelessWidget {
  const second_sunday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Year Sunday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      drawer: const second_year_drawer(),
      body: routine_model('second year', 'sunday'),
    );
  }
}

class second_monday_routine extends StatelessWidget {
  const second_monday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Year Monday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const second_year_drawer(),
      body: routine_model('second year', 'monday'),
    );
  }
}

class second_tuesday_routine extends StatelessWidget {
  const second_tuesday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Year Tuesday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const second_year_drawer(),
      body: routine_model('second year', 'tuesday'),
    );
  }
}

class second_wednesday_routine extends StatelessWidget {
  const second_wednesday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Year Wednesday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const second_year_drawer(),
      body: routine_model('second year', 'wednesday'),
    );
  }
}

class third_saturday_routine extends StatelessWidget {
  const third_saturday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Third Year Saturday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const third_year_drawer(),
      body: routine_model('third year', 'saturday'),
    );
  }
}

class third_sunday_routine extends StatelessWidget {
  const third_sunday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Third Year Sunday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const third_year_drawer(),
      body: routine_model('third year', 'sunday'),
    );
  }
}

class third_monday_routine extends StatelessWidget {
  const third_monday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Third Year Monday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const third_year_drawer(),
      body: routine_model('third year', 'monday'),
    );
  }
}

class third_tuesday_routine extends StatelessWidget {
  const third_tuesday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Third Year Tuesday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const third_year_drawer(),
      body: routine_model('third year', 'tuesday'),
    );
  }
}

class third_wednesday_routine extends StatelessWidget {
  const third_wednesday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Third Year Wednesday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const third_year_drawer(),
      body: routine_model('third year', 'wednesday'),
    );
  }
}

class fourth_saturday_routine extends StatelessWidget {
  const fourth_saturday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fourth Year Saturday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const fourth_year_drawer(),
      body: routine_model('fourth year', 'saturday'),
    );
  }
}

class fourth_sunday_routine extends StatelessWidget {
  const fourth_sunday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fourth Year Sunday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const fourth_year_drawer(),
      body: routine_model('fourth year', 'sunday'),
    );
  }
}

class fourth_monday_routine extends StatelessWidget {
  const fourth_monday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fourth Year Monday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const fourth_year_drawer(),
      body: routine_model('fourth year', 'monday'),
    );
  }
}

class fourth_tuesday_routine extends StatelessWidget {
  const fourth_tuesday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fourth Year Tuesday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const fourth_year_drawer(),
      body: routine_model('fourth year', 'tuesday'),
    );
  }
}

class fourth_wednesday_routine extends StatelessWidget {
  const fourth_wednesday_routine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fourth Year Wednesday",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: const fourth_year_drawer(),
      body: routine_model('fourth year', 'wednesday'),
    );
  }
}
