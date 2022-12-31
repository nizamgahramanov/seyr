import 'package:encrypt/encrypt.dart';

class EnDeCryption {
  static const enDeCryptionKey = "This 32 char key have 256 bits..";
  ///Encrypts the given plainText using the key. Returns encrypted data
  Encrypted encryptWithAES(String plainText) {
    final cipherKey = Key.fromUtf8(enDeCryptionKey);
    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(enDeCryptionKey.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  ///Accepts encrypted data and decrypt it. Returns plain text
  String decryptWithAES(Encrypted encryptedData) {
    final cipherKey = Key.fromUtf8(enDeCryptionKey);
    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc)); //Using AES CBC encryption
    final initVector = IV.fromUtf8(enDeCryptionKey.substring(0, 16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

    return encryptService.decrypt(encryptedData, iv: initVector);
  }
  bool isPasswordCorrect(String enteredPassword, String base16Encrypted) {
    String decryptedPassword = EnDeCryption().decryptWithAES(Encrypted.fromBase16(base16Encrypted));
    if(enteredPassword==decryptedPassword){
      return true;
    } else {
      return false;
    }
  }
}