import 'package:aes_crypt/aes_crypt.dart';

class EncryptData {
  static String encrypt_file(String path) {
    AesCrypt crypt = AesCrypt();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    crypt.setPassword('my cool password');
    String encFilepath;
    try {
      encFilepath = crypt.encryptFileSync(path);
    } catch (e) {
      if (!(e.type == AesCryptExceptionType.destFileExists)) {
        return 'ERROR';
      }
    }
    return encFilepath;
  }

  static String decrypt_file(String path) {
    AesCrypt crypt = AesCrypt();
    crypt.setOverwriteMode(AesCryptOwMode.on);
    crypt.setPassword('my cool password');
    String decFilepath;
    print(path);
    try {
      decFilepath = crypt.decryptFileSync(path);
    } catch (e) {
      print(e);
      return 'ERROR';
    }
    return decFilepath;
  }
}
