import 'package:uuvpn/constant/app_urls.dart';
import 'package:uuvpn/entity/server_entity.dart';
import 'package:uuvpn/utils/http_util.dart';

class ServerService {
  Future<List<ServerEntity>> server() {
    return HttpUtil.instance.get(AppUrls.server).then((result) {
      return serverEntityFromList(result['data']);
    });
  }
}
