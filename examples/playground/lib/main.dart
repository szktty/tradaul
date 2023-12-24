import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tradaul/tradaul.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tradaul Playground',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tradaul Playground Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    // redirect Lua stdout and stderr to this stream
    final stdout = StreamController<List<int>>();
    stdout.stream.listen((event) {
      _resultController.text += String.fromCharCodes(event);
    });
    _luaSystem = LuaSystem(stdout: stdout.sink, stderr: stdout.sink);
  }

  // LuaSystem handles stdin, stdout, stderr
  late final LuaSystem _luaSystem;

  final _sourceController = TextEditingController();
  final _resultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tradaul Playground'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: 'Input Lua source code...'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontFamily: 'RobotoMono'),
                  controller: _sourceController,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  decoration:
                      const InputDecoration(hintText: 'Execution result'),
                  readOnly: true,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(fontFamily: 'RobotoMono'),
                  controller: _resultController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        _resultController.clear();

                        final source = _sourceController.text;
                        if (source.isEmpty) {
                          return;
                        }

                        // create a Lua context
                        final context = await LuaContext.create(
                          options: LuaContextOptions(
                            system: _luaSystem,
                          ),
                        );

                        // execute the Lua source code
                        final result = await context.execute(source);
                        if (result.isSuccess()) {
                          // the result contains multiple return values
                          final values = result.getOrThrow();

                          // `LuaValue.luaToDisplayString` converts a Lua value to a display string (unquotes strings)
                          _resultController.text += values
                              .map((e) => e.luaToDisplayString())
                              .join('\t');
                        } else {
                          // `LuaExceptionContext.toDisplayString` provides a description of the stacktrace
                          _resultController.text +=
                              result.exceptionOrNull()!.toDisplayString();
                        }
                      },
                      child: const Text('Run'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _sourceController.clear();
                        _resultController.clear();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
