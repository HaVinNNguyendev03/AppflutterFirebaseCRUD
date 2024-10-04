import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Employee',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'From',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // input name
            const Text(
              "Name",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter Name'),
              ),
            ),
            // input age
            const SizedBox(height: 10),
            const Text(
              "Age",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),

            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter Age'),
              ),
            ),
            // input location
            const SizedBox(height: 10),
            const Text(
              "Loaction",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter Location'),
              ),
            ),
            SizedBox(height: 30),
            //button add
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String Id = randomAlphaNumeric(10);
                  Map<String, dynamic> employeeInfoMap = {
                    "Name": nameController.text,
                    "Age": ageController.text,
                    "Id": Id,
                    "Location": locationController.text
                  };
                  await DatabaseMethods()
                      .addEmployeeDetails(employeeInfoMap, Id)
                      .then((value) {
                    Fluttertoast.showToast(
                        msg: "dữ liệu đã thêm thành công",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: const Color.fromARGB(255, 9, 255, 0),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                },
                child: Text(
                  "Add",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
