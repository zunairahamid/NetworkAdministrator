package clientinfo;
import java.io.*;
public class ClientInfo implements Runnable{
	public ClientInfo() {}
public void run() {
	try {
		Process process=Runtime.getRuntime().exec("./ClientInfo.sh");
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
