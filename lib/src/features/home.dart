import 'package:flutter/material.dart';
import 'package:pixels_assignment/src/services/api.dart';
import 'package:pixels_assignment/src/constants/styles.dart';
import 'package:pixels_assignment/src/model/model.dart';

enum Gender { male, female}

class User {
  // This is an instence if enum so that is can convert Gender.MALE to male and Gender.FEMALE to female
  final Gender gender;
  User(this.gender);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<UserDetails> userdetails;
  bool isdatarecived = false;
  Gender? selectedGender;
  double selectedAge = 50;

  @override
  void initState() {
    super.initState();
    userdetails = fetchdetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("pixel", style: Styles.appBarstyle1),
            Text("6", style: Styles.appBarstyle2),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.red),
          ) 
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Employee', style: Styles.heading1),
                const SizedBox(width:50,),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffFEC400)),
                    borderRadius: BorderRadius.circular(8)
                  ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DropdownButton<Gender>(    
                        underline: const SizedBox(),                  
                        elevation: 2,
                        isExpanded: true,
                        hint: Text("Gender",style: Styles.heading1),
                        value: selectedGender,
                        onChanged: (Gender? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: Gender.values.map((Gender gender) {
                          return DropdownMenuItem<Gender>(
                            value: gender,
                            child: Text(gender.toString().split('.').last,style: Styles.heading1),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Text('Age: ${selectedAge.round()}',style: Styles.heading1),
                      Slider(
                        value: selectedAge,
                        min: 0,
                        max: 70,
                        divisions:70,
                        label: selectedAge.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            selectedAge = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height:30,
            color:const Color(0xffFEC400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Text('Id', style: Styles.heading2)),
                  Expanded(flex: 3, child: Text('Image', style: Styles.heading2)),
                  Expanded(flex: 6, child: Text('Employee Name', style: Styles.heading2)),
                  Expanded(flex: 3, child: Text('Gender', style: Styles.heading2)),
                  Expanded(flex: 0, child: Text('Age', style: Styles.heading2)),
                ],
              ),
            ),
          ),
          FutureBuilder<UserDetails>(
            future: fetchdetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // creating the new list for the filtered users and assigning to it.
                var filteredUsers = snapshot.data!.users.where((user) {
                  bool matchesGender = selectedGender == null ||
                      user.gender.toString().split('.').last.toLowerCase() ==
                          selectedGender.toString().split('.').last.toLowerCase();
                  bool matchesAge = user.age <= selectedAge;
                  return matchesGender && matchesAge;
                }).toList();
              return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      // assigning all the filtered user object to a new user variable.
                      var user = filteredUsers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 3),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xffFEC400),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Text('${user.id}', style: Styles.heading2),
                                Expanded(
                                  flex: 3,
                                  child: CircleAvatar(
                                    child: Image.network(user.image),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    '${user.firstName} ${user.maidenName} ${user.lastName}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.heading2,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    user.gender.toString().split('.').last.toLowerCase(),
                                    style: Styles.heading2,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('${user.age}', style: Styles.heading2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 250),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
