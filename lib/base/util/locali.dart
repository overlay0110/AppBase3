import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

const en = {
  'test': 'Hello World',
  'call':'call',
  'internet_error' : "The network status is not smooth. Please try again in a few minutes.",
  'finish_mess' : "Press again to exit.",
  'root_mess' : "Rooted phones or mobile phones may remain rooted history. And prevent accidents such as the use of hacking character limit for App rooted phones.",
  'ok' : "OK",
  'ok2' : "Continue",
  'cancel':"Cancel",
  'next' : "Next",
  'submit' : "Submit",
  'home' : "Home",
  'prev' : "Previous",
  'success' : "Complete",
  'sel_lock_str': "Select screen lock.",
  'password_input' : "Please enter a password.",
  'password_error' : "Password does not match.",
  'password_error_reset' : "Password does not match. \nPlease try again from the beginning.",
  're_input' : "Please enter one more time to confirm.",
  'finger_input' : "Touch the fingerprint sensor.",
  'version_msg' : "The current client version has expired. Download the latest version of the client.",
  'trans_test' : 'Localization test',
};

const ko = {
  'test': '안녕 세계',
  'call':'호출하기',
  'internet_error' : "네트워크 상태가 원활하지 않습니다. 잠시 후 다시 시도해 주세요.",
  'finish_mess' : "한번 더 누르시면 종료됩니다.",
  'root_mess' : "휴대폰이 루팅폰이거나 루팅 기록이 남아있습니다. 해킹 등의 사고를 막고자 루팅폰의 앱 사용을 제한하고 있습니다.",
  'ok' : "확인",
  'ok2' : "계속",
  'cancel':"취소",
  'next' : "다음",
  'submit' : "등록",
  'home' : "홈",
  'prev' : "이전",
  'success' : "완료",
  'sel_lock_str': "화면 잠금 선택",
  'password_input' : "PIN 번호를 입력해주세요.",
  'password_error' : "비밀번호가 일치하지 않습니다.",
  'password_error_reset' : "비밀번호가 일치하지 않습니다. \n처음부터 다시 시도해주세요.",
  're_input' : "PIN 번호를 한 번 더 입력해주세요.",
  'finger_input' : "지문센서를 터치해 주세요.",
  'version_msg' : "현재 클라이언트 버전은 유효기간이 지났습니다. 최신 버전의 클라이언트를 다운로드 받으세요.",
  'trans_test' : '다국어 테스트',
};

class Strings {
  Strings(this.locale);
  final Locale locale;
  static Strings of(BuildContext context) {
    return Localizations.of<Strings>(context, Strings)!;
  }
  static const _localizedValues = <String, Map<String, String>>{
    'en': en,
    'ko': ko,
  };
  static List<String> languages ()=> _localizedValues.keys.toList();
  String trans(String key) {
    return _localizedValues[locale.languageCode]![key]!;
  }

  String getLanCode(){
    return locale.languageCode;
  }
}

class LocaliDelegate extends LocalizationsDelegate<Strings> {
  const LocaliDelegate();
  @override
  bool isSupported(Locale locale) => Strings.languages().contains(locale.languageCode);
  @override
  Future<Strings> load(Locale locale) {
    return SynchronousFuture<Strings>(Strings(locale));
  }
  @override
  bool shouldReload(LocaliDelegate old) => false;
}