import java.io.File;

public class Testing {
	public static void main(String[] args) {
		
		String path = System.getProperty("user.dir") + "/Train";
		Category c = new Category();
		c.addDoc(new File(path).listFiles()[0]);
		System.out.println(c.getWordProb("Archie", .95) +" " + c.totalDocs + " " + c.totalWords);
	}
}
