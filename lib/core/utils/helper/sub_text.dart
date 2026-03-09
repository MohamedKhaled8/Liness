import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:encrypt/encrypt.dart';

class SubTextUtils {
  SubTextUtils._();

  static String getRandomString({required int length}) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) {
      return chars[random.nextInt(chars.length)];
    }).join();
  }

  static Map<String, dynamic> textE({
    required String text,
  }) {
    String subTexter = getRandomString(length: 16);
    var iv = IV.fromUtf8(subTexter);
    var subText = Encrypter(
      AES(
        Key.fromUtf8(subTexter),
        mode: AESMode.ctr,
        padding: null,
      ),
    ).encrypt(text, iv: iv).base64;

    return {'subText': subText, 'subTexter': subTexter};
  }

  static String textD({
    required String subText,
    // required String kIv,
    required String subTexterK,
  }) {
    //// EXTRACT DATA FROM API
    final parts = subText.split('|');

    //// CONVERT SUBTEXTK TO BYTES
    // ignore: no_leading_underscores_for_local_identifiers
    final _subTexterKBy = Uint8List.fromList(HEX.decode(subTexterK));

    final Uint8List encryptedBytesWithSalt = base64.decode(parts[1]);

    //// GET IV FROM BASE64
    var iv = IV.fromBase64(parts[0]);

    //// CONVERT SUBTEXT TO BYTES
    final Uint8List encryptedBytes = encryptedBytesWithSalt.sublist(
      0,
      encryptedBytesWithSalt.length,
    );

    //// CONVERT SUBTEXT TO TEXT
    final String decrypted = Encrypter(
      AES(
        Key(_subTexterKBy),
        mode: AESMode.ctr,
        padding: null,
      ),
    ).decrypt(
      Encrypted(encryptedBytes),
      iv: iv,
    );

    return decrypted;
  }
}
