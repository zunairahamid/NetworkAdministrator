import java.io.*;
import java.net.*;
import java.util.Scanner;

public class Client1 {

    // Method to run shell scripts, with optional interactive inputs
    private static StringBuilder runScript(String pathOfScript, String... inputs) {
        StringBuilder result = new StringBuilder();
        try {
            ProcessBuilder pb = new ProcessBuilder("bash", pathOfScript);
            Process process = pb.start();

            // Handle interactive inputs, if any
            try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()))) {
                for (String input : inputs) {
                    writer.write(input + "\n");
                    writer.flush();
                }
            }

            // Capture script output
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    result.append(line).append("\n");
                }
            }

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                result.append("Error: Script exited with code ").append(exitCode).append("\n");
            }

        } catch (IOException | InterruptedException e) {
            result.append("Error: ").append(e.getMessage()).append("\n");
        }

        return result;
    }

    // Method to fetch system information from the server
    private static void requestSystemInfoFromServer(Socket socket) {
        try (PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
             BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()))) {

            out.println("system_info");
            System.out.println("Receiving system information from the server:");

            String line;
            while ((line = in.readLine()) != null) {
                if ("END_OF_FILE".equals(line)) {
                    break;
                }
                System.out.println(line);
            }

        } catch (IOException e) {
            System.err.println("Error requesting system information: " + e.getMessage());
        }
    }

    public static void main(String[] args) throws InterruptedException {
        // Define shell script paths
        String checkScriptPath = "/home/client1/check.sh"; // Adjust this path
        String loginScriptPath = "/home/client1/login.sh"; // Adjust this path

        // Connect to the server
        try (Socket socket = new Socket("172.16.85.135", 1300)) {
            System.out.println("Client 1 is now connected to the Server.");

            // Execute check.sh
            System.out.println("Running check.sh...");
            StringBuilder checkOutput = runScript(checkScriptPath);
            System.out.println("Output of check.sh:");
            System.out.println(checkOutput);

            // Execute login.sh with interactive inputs
            System.out.println("Running login.sh...");
            Scanner scanner = new Scanner(System.in);
            System.out.print("Enter username: ");
            String username = scanner.nextLine();
            System.out.print("Enter password: ");
            String password = scanner.nextLine();

            StringBuilder loginOutput = runScript(loginScriptPath, username, password);
            System.out.println("Output of login.sh:");
            System.out.println(loginOutput);

            // Request system info periodically
            while (true) {
                requestSystemInfoFromServer(socket);
                Thread.sleep(300000); // 5 minutes
            }

        } catch (IOException e) {
            System.err.println("Error connecting to the server: " + e.getMessage());
        }
    }
}
