import 'package:flutter/material.dart';
import 'services/grpc_client.dart';
import 'config/grpc_config.dart';
import './compte_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test connection on startup
  final grpcClient = GrpcClient();
  bool isConnected = await grpcClient.testConnection();
  
  runApp(MyApp(isConnected: isConnected));
}

class MyApp extends StatelessWidget {
  final bool isConnected;
  
  const MyApp({Key? key, required this.isConnected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: isConnected 
          ? CompteScreen()  // Your main screen
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Cannot connect to gRPC server at ${GrpcConfig.host}:${GrpcConfig.port}'),
                  ElevatedButton(
                    onPressed: () async {
                      final grpcClient = GrpcClient();
                      bool connected = await grpcClient.testConnection();
                      if (connected) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => CompteScreen()),
                        );
                      } else {
                        // Optionally show a message if the retry fails
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Connection failed. Please try again later.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('Retry Connection'),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
