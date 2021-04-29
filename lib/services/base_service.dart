class BaseService{
  final url = 'http://192.168.100.88:50000';

  bool isSuccessCode(int code) => code >= 200 && code < 300;
}