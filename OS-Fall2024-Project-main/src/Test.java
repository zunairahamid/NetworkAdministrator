package search;

public class Test {
	public static void main(String[]args) {
Thread t=new Thread(new Search());
t.start();
}
}