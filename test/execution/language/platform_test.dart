import 'dart:io';

import 'package:test/test.dart';
import 'package:tradaul/src/runtime/lua_table.dart';

import 'test.dart';

void main() {
  group('"platform" module', () {
    test('"os"', () async {
      const source = 'return platform.os';
      expect(await luaExecute(source), luaEquals([Platform.operatingSystem]));
    });

    test('"isandroid"', () async {
      const source = 'return platform.isandroid';
      expect(await luaExecute(source), luaEquals([Platform.isAndroid]));
    });

    test('"isfuchsia"', () async {
      const source = 'return platform.isfuchsia';
      expect(await luaExecute(source), luaEquals([Platform.isFuchsia]));
    });

    test('"isios"', () async {
      const source = 'return platform.isios';
      expect(await luaExecute(source), luaEquals([Platform.isIOS]));
    });

    test('"islinux"', () async {
      const source = 'return platform.islinux';
      expect(await luaExecute(source), luaEquals([Platform.isLinux]));
    });

    test('"ismac"', () async {
      const source = 'return platform.ismac';
      expect(await luaExecute(source), luaEquals([Platform.isMacOS]));
    });

    test('"iswindows"', () async {
      const source = 'return platform.iswindows';
      expect(await luaExecute(source), luaEquals([Platform.isWindows]));
    });

    test('"osversion"', () async {
      const source = 'return platform.osversion';
      expect(
        await luaExecute(source),
        luaEquals([Platform.operatingSystemVersion]),
      );
    });

    test('"version"', () async {
      const source = 'return platform.version';
      expect(await luaExecute(source), luaEquals([Platform.version]));
    });

    test('"locale"', () async {
      const source = 'return platform.locale';
      expect(await luaExecute(source), luaEquals([Platform.localeName]));
    });

    test('"host"', () async {
      const source = 'return platform.host';
      expect(await luaExecute(source), luaEquals([Platform.localHostname]));
    });

    test('"environment"', () async {
      const source = 'return platform.environment';
      expect(await luaExecute(source), luaEquals([luaIsA<LuaTable>()]));
    });
  });
}
