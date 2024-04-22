import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu de Maestros',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AttendanceRecord> _attendanceRecords = [
    AttendanceRecord(classroom: 'A101', schedule: '9:00 AM - 10:00 AM', day: 'Monday', attended: true),
    AttendanceRecord(classroom: 'B205', schedule: '11:00 AM - 12:00 PM', day: 'Wednesday', attended: false),
    // Add more records here...
  ];

  List<AttendanceRecord> _absenceRecords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú de Maestros')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Opciones',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildDrawerOption(
              context,
              'Registro de Entrada y Salida',
              Icons.schedule,
              () {
                _showEntryOptionsDialog(context);
              },
            ),
            _buildDrawerOption(
              context,
              'Consulta de Asistencias',
              Icons.assignment,
              () {
                _showAttendanceQueryDialog(context);
              },
            ),
            _buildDrawerOption(
              context,
              'Consulta de Inasistencias',
              Icons.warning,
              () {
                _showAbsenceQueryDialog(context);
              },
            ),
            _buildDrawerOption(
              context,
              'Filtro de Búsqueda',
              Icons.search,
              () {
                // Implementa la lógica para el filtro de búsqueda
              },
            ),
            _buildDrawerOption(
              context,
              'Asistencias Justificadas',
              Icons.check_circle,
              () {
                // Implementa la lógica para las asistencias justificadas
              },
            ),
            _buildDrawerOption(
              context,
              'Faltas Injustificadas',
              Icons.cancel,
              () {
                // Implementa la lógica para las faltas injustificadas
              },
            ),
            _buildDrawerOption(
              context,
              'Informes de Asistencias Injustificadas',
              Icons.report,
              () {
                // Implementa la lógica para los informes de asistencias injustificadas
              },
            ),
            _buildDrawerOption(
              context,
              'Descarga de Informes',
              Icons.download,
              () {
                // Implementa la lógica para la descarga de informes
              },
            ),
            _buildDrawerOption(
              context,
              'Alumnos por Materia',
              Icons.people_alt,
              () {
                // Implementa la lógica para la visualización de alumnos por materia
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _attendanceRecords.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Registro ${index + 1}'),
            subtitle: Text('Estado: ${_attendanceRecords[index].attended ? 'Asistió' : 'No asistió'}'),
            onTap: () {
              _toggleAttendance(index);
            },
          );
        },
      ),
    );
  }

  Widget _buildDrawerOption(BuildContext context, String title, IconData icon, Function() onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showEntryOptionsDialog(BuildContext context) async {
    DateTime now = DateTime.now(); // Obtener la fecha y hora actual

    List<String> options = ['Presente', 'Retrasado', 'Excusado', 'Ausente']; // Opciones disponibles

    List<String> selectedOptions = []; // Opciones seleccionadas por el usuario

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registro de Entrada y Salida'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Construir las opciones de selección múltiple
                  for (var option in options)
                    CheckboxListTile(
                      title: Text(option),
                      value: selectedOptions.contains(option),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            selectedOptions.add(option);
                          } else {
                            selectedOptions.remove(option);
                          }
                        });
                      },
                    ),
                  ElevatedButton(
                    onPressed: () {
                      // Verificar si el maestro está ausente automáticamente debido a la tolerancia de 15 minutos
                      if (selectedOptions.isEmpty && now.minute >= 15) {
                        selectedOptions.add('Ausente');
                      }

                      _saveEntryRecord(selectedOptions, now);
                      Navigator.of(context).pop();
                      _showMessage('Cambios guardados');
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _saveEntryRecord(List<String> selectedOptions, DateTime dateTime) {
    // Guardar el registro de entrada y salida
    if (selectedOptions.contains('Ausente')) {
      _absenceRecords.add(AttendanceRecord(
        classroom: 'Nuevo aula', // Solo para demostración, puedes ajustar esto según tu lógica
        schedule: 'Nuevo horario', // Solo para demostración, puedes ajustar esto según tu lógica
        day: 'Nuevo día', // Solo para demostración, puedes ajustar esto según tu lógica
        attended: false, // Marcar como no asistió
      ));
    } else {
      _attendanceRecords.add(AttendanceRecord(
        classroom: 'Nuevo aula', // Solo para demostración, puedes ajustar esto según tu lógica
        schedule: 'Nuevo horario', // Solo para demostración, puedes ajustar esto según tu lógica
        day: 'Nuevo día', // Solo para demostración, puedes ajustar esto según tu lógica
        attended: true, // Marcar como asistió
      ));
    }
  }

  void _showAttendanceQueryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Consulta de Asistencias'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Display the attendance records
              for (var record in _attendanceRecords) _buildAttendanceRecord(context, record),
            ],
          ),
        );
      },
    );
  }

  void _showAbsenceQueryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Consulta de Inasistencias'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var record in _absenceRecords)
                ListTile(
                  title: Text('Aula: ${record.classroom}, Horario: ${record.schedule}'),
                ),
            ],
          ),
        );
      },
    );
  }

  void _toggleAttendance(int index) {
    setState(() {
      _attendanceRecords[index].attended = !_attendanceRecords[index].attended;
      if (!_attendanceRecords[index].attended) {
        _absenceRecords.add(_attendanceRecords[index]);
      }
    });
  }

  Widget _buildAttendanceRecord(BuildContext context, AttendanceRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aula: ${record.classroom}'),
        Text('Horario: ${record.schedule}'),
        Text('Día: ${record.day}'),
        Row(
          children: [
            Text('¿Asistió? '),
            ElevatedButton(
              onPressed: () {
                _toggleAttendance(_attendanceRecords.indexOf(record));
                Navigator.pop(context); // Cerrar el diálogo después de cambiar la asistencia
              },
              child: Text('Sí'),
            ),
            ElevatedButton(
              onPressed: () {
                _toggleAttendance(_attendanceRecords.indexOf(record));
                Navigator.pop(context); // Cerrar el diálogo después de cambiar la asistencia
              },
              child: Text('No'),
            ),
          ],
        ),
        Divider(), // Add a divider between records for better visual separation
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class AttendanceRecord {
  String classroom;
  String schedule;
  String day;
  bool attended;

  AttendanceRecord({required this.classroom, required this.schedule, required this.day, required this.attended});
}





















