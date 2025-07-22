package search;
import java.io.BufferedReader;
import java.io.InputStreamReader;
public class Search implements Runnable{
	public Search() {}
public void run() {
	try {
		Process process=Runtime.getRuntime().exec("./Search.sh");
BufferedReader reader=new BufferedReader(new InputStreamReader(process.getInputStream()));
String line;
while((line=reader.readLine())!=null) {
	System.out.println(line);
}
	} catch(Exception e) {
		System.out.println(e.getStackTrace());
	}
}
}
