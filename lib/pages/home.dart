import 'package:app/pages/employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/services/database.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  Stream? EmployeeStream;
  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }
  @override
  void initState() {
    getontheload();
    super.initState();
  }
 Widget allEmployeeDetails() {
  return StreamBuilder(
    stream: EmployeeStream,
    builder: (context, AsyncSnapshot snapshot) {
      // Kiểm tra nếu có dữ liệu
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data.docs.length, // Đảm bảo có itemCount
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10.0), 
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  padding: const EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        
                        children: [
                          Text(
                            "Name : " + ds['Name'],
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                              onTap: () {
                                nameController.text = ds['Name'];
                                ageController.text = ds['Age'];
                                locationController.text = ds['Location'];
                                EditEmployee(ds["Id"]);
                              }, 
                              child: 
                                Icon(Icons.edit, color: Colors.orange)),
                                SizedBox(width: 5.0,),
                                GestureDetector(
                                  onTap: () async {
                                    await DatabaseMethods().deleteEmployeeDetail(ds["Id"]);
                                    
                                  },
                                  child: Icon(Icons.delete, color: Colors.red)),
                        ],
                      ),
                      Text(
                        "Age : " + ds['Age'],
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        "Location : " + ds['Location'],
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        // Trường hợp không có dữ liệu
        return Container(
          color: const Color.fromARGB(255, 0, 0, 0),
        );
      }
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Employee()));
      }, child: Icon(Icons.add),),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fluter',style: TextStyle(color: Colors.blue,fontSize: 20.0,fontWeight: FontWeight.bold),),
            Text('Firebase',style: TextStyle(color: Colors.orange,fontSize: 20.0,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(child: allEmployeeDetails()),
          ],
        ),
      ),
    );
  }

  Future EditEmployee(String id) => showDialog(context: context, builder: (context) => AlertDialog(
    content: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.cancel),
            ),
            SizedBox(width: 80.0),
            Text('Edit',style: TextStyle(color: Colors.blue,fontSize: 20.0,fontWeight: FontWeight.bold),),
            Text('Details',style: TextStyle(color: Colors.orange,fontSize: 20.0,fontWeight: FontWeight.bold),),
          ],),
           Text(
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
            const SizedBox(height: 30.0),
            Center(child: ElevatedButton(onPressed: () async{
              Map<String, dynamic> updateInfo = {
                "Name": nameController.text,
                "Age": ageController.text,
                "Id": id,
                "Location": locationController.text
              };
              await DatabaseMethods().updateEmployeeDetail(id, updateInfo).then((value) {
                Navigator.pop(context);
              });
            }, child: Text("Update")))
        ],
      )
    ),
  ));
  // Future<void> deleteEmployee(String id) async {
  //   await DatabaseMethods().deleteEmployee(id);
  // }

}