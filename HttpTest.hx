package;
import haxe.Http;
import haxe.Json;

/**
 * test de la class haxe http
 * execute une requete sur l'API tweeter
 * cherche des tweets correspondant à un mot clef
 * retourne la liste des tweets et ses auteurs
 * compilation + execution : haxe HttpTest.hxml && neko HttpTest.n -q "mon mot clef"
 */
class HttpTest{
	
	public static function main(){
		trace("test get");
		var args:Array<String> = Sys.args();
		var query = Lambda.indexOf(args, "-q");
		var queryString:String= "twitter";
		if (query>=0 && args[query+1]!=null) {
			queryString = args[query + 1];
		}
		
		var http:Http = new Http("search.twitter.com/search.json?q="+queryString);
		http.cnxTimeout = 2;
		http.onData = function(data) {
			var datas:Dynamic = Json.parse(data);
			var results:Array<Dynamic> = datas.results;
			for ( result in results) {
				trace(result.from_user);
				trace(result.text);

			}
		};
		http.onStatus = function(status) { trace("status = " + status); };
		http.onError = function(error) { trace("error = " + error); };
		http.request(true);
	}
}