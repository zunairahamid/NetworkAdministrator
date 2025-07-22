import java.io.*;
import java.net.*;
import java.util.ArrayList;
import java.util.concurrent.locks.ReentrantLock;

public class Server {
    private static final int PORT = 1300; // Port for the server to listen on
    private static ArrayList<ClientInfo> clients = new ArrayList<>(); // List of connected clients
    private static ReentrantLock lock = new ReentrantLock(); // Lock to ensure synchronization

    public static void main(String[] args) {
        System.out.println("Server is running on port " + PORT + "...");

        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            while (true) {
                Socket clientSocket = serverSocket.accept(); // Accept incoming connections
                System.out.println("Accepted connection from " + clientSocket.getInetAddress());

                // Run Network.sh to verify the connection
                runNetworkScript();

                // Handle each client in a separate thread
                ClientHandler clientHandler = new ClientHandler(clientSocket);
                clientHandler.start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Run Network.sh script on client connection
    private static void runNetworkScript() {
        try {
            ProcessBuilder pb = new ProcessBuilder("/home/server/Network.sh");
            pb.start(); // Run the script
        } catch (IOException e) {
            System.err.println("Error running Network.sh: " + e.getMessage());
        }
    }

    // Add client information to the list
    private static void addClient(String clientAddress, int clientPort) {
        lock.lock();
        try {
            clients.add(new ClientInfo(clientAddress, clientPort));
        } finally {
            lock.unlock();
        }
    }

    // Display the list of connected clients
    private static void displayClients() {
        lock.lock();
        try {
            System.out.println("Connected Clients:");
            for (ClientInfo client : clients) {
                System.out.println(client);
            }
        } finally {
            lock.unlock();
        }
    }

    // Class to handle individual client connections
    private static class ClientHandler extends Thread {
        private Socket socket;

        public ClientHandler(Socket socket) {
            this.socket = socket;
        }

        @Override
        public void run() {
            try {
                addClient(socket.getInetAddress().toString(), socket.getPort());
                displayClients();

                BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

                String clientRequest;
                while ((clientRequest = in.readLine()) != null) {
                    System.out.println("Client Request: " + clientRequest);

                    if (clientRequest.equalsIgnoreCase("system_info")) {
                        File systemInfo = runSystemInfoScript();
                        sendFileToClient(systemInfo, out);
                    } else {
                        out.println("Invalid request.");
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    socket.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        // Run system.sh script to gather system info
        private File runSystemInfoScript() throws IOException {
            ProcessBuilder pb = new ProcessBuilder("/home/server/System.sh");
            File outputFile = new File("system_info.log");
            pb.redirectOutput(outputFile);
            pb.start();
            return outputFile;
        }

        // Send the system info file to the client
        private void sendFileToClient(File file, PrintWriter out) throws IOException {
            try (BufferedReader fileReader = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = fileReader.readLine()) != null) {
                    out.println(line); // Send each line of the file
                }
            }
            out.println("END_OF_FILE"); // Indicate end of file transfer
        }
    }

    // Class to store client information
    private static class ClientInfo {
        private String address;
        private int port;

        public ClientInfo(String address, int port) {
            this.address = address;
            this.port = port;
        }

        @Override
        public String toString() {
            return "Client [Address: " + address + ", Port: " + port + "]";
        }
    }
}
