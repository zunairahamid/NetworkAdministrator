import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;

public class Client2 {

	    public static void main(String[] args) {
	        try {
	            // Connect to the server
	            Socket socket = new Socket("172.16.85.135", 1300);
	            System.out.println("Connected to the server.");

	            // Run search.sh and display the output
	            System.out.println("Running Search.sh...");
	            runShellScript("/home/client2/Search.sh");

	            // Run clientinfo.sh and display the output
	            System.out.println("Running Clientinfo.sh...");
	            runShellScript("/home/client2/Clientinfo.sh");

	            // Request system info from the server
	            DataOutputStream out = new DataOutputStream(socket.getOutputStream());
	            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

	            out.writeUTF("REQUEST_SYSTEM_INFO");

	            // Receive the file from the server
	            String fileName = "system_info_client2.txt";
	            receiveFile(socket, fileName);

	            // Display the received file content
	            System.out.println("Displaying content of the received file:");
	            displayFileContent(fileName);

	            // Close the connection
	            socket.close();
	            System.out.println("Disconnected from the server.");

	        } catch (IOException e) {
	            System.err.println("Error: " + e.getMessage());
	        }
	    }

	    // Method to run a shell script and display its output
	    private static void runShellScript(String scriptPath) {
	        try {
	            Process process = Runtime.getRuntime().exec(scriptPath);
	            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
	            String line;
	            while ((line = reader.readLine()) != null) {
	                System.out.println(line);
	            }
	            reader.close();
	        } catch (IOException e) {
	            System.err.println("Error running shell script: " + scriptPath + ". " + e.getMessage());
	        }
	    }

	    // Method to receive a file from the server
	    private static void receiveFile(Socket socket, String fileName) {
	        try {
	            DataInputStream in = new DataInputStream(socket.getInputStream());
	            FileOutputStream fileOut = new FileOutputStream(fileName);

	            int bytesRead;
	            byte[] buffer = new byte[4096];

	            while ((bytesRead = in.read(buffer)) != -1) {
	                fileOut.write(buffer, 0, bytesRead);
	            }

	            fileOut.close();
	            System.out.println("File received: " + fileName);

	        } catch (IOException e) {
	            System.err.println("Error receiving file: " + e.getMessage());
	        }
	    }

	    // Method to display the content of a file
	    private static void displayFileContent(String fileName) {
	        try {
	            BufferedReader reader = new BufferedReader(new FileReader(fileName));
	            String line;
	            while ((line = reader.readLine()) != null) {
	                System.out.println(line);
	            }
	            reader.close();
	        } catch (IOException e) {
	            System.err.println("Error displaying file content: " + e.getMessage());
	        }
	    }

}
