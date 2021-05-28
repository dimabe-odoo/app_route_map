class BaseService{
  final url = 'https://dimabe-odoo-ambienteslimpiossa-test-2361998.dev.odoo.com';

  bool isSuccessCode(int code) => code >= 200 && code < 300;
}