import 'dart:io';

void main(List<String> args) async {
  print('🚀 開始構建流程...');
  
  // 檢查 FVM Flutter 是否可用
  final flutterResult = await Process.run('fvm', ['flutter', '--version']);
  if (flutterResult.exitCode != 0) {
    print('❌ FVM Flutter 不可用，請確認已安裝 FVM 並設定 Flutter 3.24.4');
    exit(1);
  }
  
  try {
    // 1. 安裝依賴
    print('\n📦 安裝依賴...');
    final pubGetResult = await Process.run('fvm', ['flutter', 'pub', 'get']);
    if (pubGetResult.exitCode != 0) {
      print('❌ pub get 失敗');
      print(pubGetResult.stderr);
      exit(1);
    }
    print('✅ 依賴安裝完成');
    
    // 2. 生成 Realm 模型
    print('\n🏗️  生成 Realm 模型...');
    final realmResult = await Process.run('fvm', [
      'dart',
      'run',
      'realm',
      'generate'
    ]);
    
    if (realmResult.exitCode != 0) {
      print('❌ Realm 模型生成失敗');
      print(realmResult.stderr);
      exit(1);
    }
    print('✅ Realm 模型生成完成');
    
    // 3. 生成其他代碼
    print('\n🔨 生成其他代碼...');
    final buildRunnerResult = await Process.run('fvm', [
      'dart',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs'
    ]);
    
    if (buildRunnerResult.exitCode != 0) {
      print('❌ 代碼生成失敗');
      print(buildRunnerResult.stderr);
      exit(1);
    }
    print('✅ 代碼生成完成');
    
    // 4. 生成應用圖標
    print('\n🎨 生成應用圖標...');
    final iconResult = await Process.run('fvm', [
      'flutter',
      'pub',
      'run',
      'flutter_launcher_icons:main'
    ]);
    
    if (iconResult.exitCode != 0) {
      print('⚠️  圖標生成失敗（可能是因為圖標文件不存在）');
      print(iconResult.stderr);
    } else {
      print('✅ 應用圖標生成完成');
    }
    
    print('\n🎉 構建流程完成！');
    print('現在可以執行 fvm flutter run 來啟動應用');
    
  } catch (e) {
    print('❌ 構建過程中發生錯誤：$e');
    exit(1);
  }
}