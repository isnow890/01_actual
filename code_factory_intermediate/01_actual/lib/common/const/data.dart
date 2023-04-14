import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY ='ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
//스토리지 생성
final storage = FlutterSecureStorage();


final emulatorIp = '10.0.2.2:3000';
final simulatorIp = '127.0.0.1:3000';

//런타임에 어떤 운영체제에서 사용중인지 알수 있음.
final ip = Platform.isIOS ? simulatorIp : emulatorIp;

