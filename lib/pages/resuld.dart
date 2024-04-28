import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String place;
  const Result({super.key, required this.place});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {

    Future<Map<String, dynamic>> getDataFromApi() async {
      final response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=0669e771943a280d7c17024e4cbdad30&units=metric"));
       
       if(response.statusCode == 200) {
            final data = json.decode(response.body);

            return data;
       } else {
        throw Exception("error");
       }
    }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "hasil Tracking", 
            style: TextStyle(color: Colors.white
          ),),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);

            },
            child: const Icon(Icons.arrow_back, color: Colors.white,),
          )),

          body: Container(
            padding: const EdgeInsets.only(left : 70, right: 70),

            child:FutureBuilder(
              future: getDataFromApi(), 
              builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                    }

                    if (snapshot.hasData) {
                        final data = snapshot.data!;

                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(image: NetworkImage('https://flagsapi.com/${data["sys"]["country"]}/shiny/64.png'))
                              ,Text("suhu: ${data["main"]["feels_like"]} C",
                              style: const TextStyle(
                                fontSize: 20
                              ),),


                              Text('kecepatan angin: ${data["wind"]["speed"]} m/s',
                                style: const TextStyle(
                                fontSize: 20
                              ),),

                              
                            ],
                          ),
                        );
                    } else{
                        return const Text(" tempat tidak diketahui");
                    }

                },
              ),
          ) 
      ),
    );
  }
}