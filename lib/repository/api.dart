import '../../constants/IConstants.dart';
import 'package:http/http.dart' as http;
class Api{
  Map<String, String> _header;
  Map<String, String> _body;
  List<Map<String, dynamic>> files;
  String baseurl = "${IConstants.API_PATH}v2/";
  set header(Map<String,String> header)=> this._header = header;
  Map<String, String> get header => _header;
  set body(Map<String,String> body)=>this._body = body;
  Map<String, String> get body => _body;
  Future<String> Geturl(String url,{isv2 = true}) async {
    print('${isv2?baseurl:IConstants.API_PATH}$url');
    var headers = header?? {
    'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request('GET', Uri.parse('${isv2?baseurl:IConstants.API_PATH}$url'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return Future.value(await response.stream.bytesToString());
      // print(await response.stream.bytesToString());
    }
    else {
      print("status response..."+await response.reasonPhrase);
      return Future.value(response.reasonPhrase);
      //
      // print(response.reasonPhrase);
    }

  }
  Future<String> Posturl(String url,{isv2 = true}) async {
    print("sending post with url: ${isv2?baseurl:IConstants.API_PATH}$url and parm: "+body.toString());

    Map<String,String> headers = header?? {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    final request = http.Request('POST', Uri.parse('${isv2?baseurl:IConstants.API_PATH}$url'),);
    // if(files.isNotEmpty){
    //   files.map((e) {
    //     e.map((key, value)  => );
    //   }).toList();
    //   // Future.delayed(Duration.zero,() async=> request.files.add(await http.MultipartFile.fromPath(key, value););
    // }
    // request.files.add(await http.MultipartFile.fromPath('language_id', '/path/to/file'));
    var bodys = body;
    request.headers.addAll(headers);
    request.bodyFields = bodys;
    http.StreamedResponse response = await request.send();
    print("status ${response.statusCode}");
    if (response.statusCode == 200) {
      final responsees =await response.stream.bytesToString();
      return Future.value(responsees);
      // print(await response.stream.bytesToString());
    }
    else {
      print("status response..."+await response.stream.bytesToString());
      return Future.value('''{"status":${response.statusCode}}''');

      // print(response.reasonPhrase);
    }

  }
}
final api = Api();