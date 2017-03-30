import java.io.File;

public class Testing {
	public static void main(String[] args) {
		
		File[] train = //Directory (array of file names) containing training documents (accessed by File.listFiles();)
		File[] test = //Directory (array of file names) containing testing documents (accessed by File.listFiles();)
		File labels = //File containing test labels
		int uniqueCats = //Number of unique categories
		
		//Then to run the model...
		Model naiveBayes = new Model(uniqueCats, labels, train, test);
		
		//To access the test document classifications...
		
		int[] predictions = naiveBayes.testClassifications;
	
	}
}
