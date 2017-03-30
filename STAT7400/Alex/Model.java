import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

public class Model {
	int numCats;
	Category[] categories;
	double[] priorProbs;
	int[] testClassifications;
	double alpha;
	
	//Input the number of categories
	//Assumes label file starts with '1', and goes up to the number of categories
	public Model(int cats, File labs, File[] train, File[] test) {
		//Weighting parameter (arbitrary)
		alpha = .95;
		
		numCats = cats;
		
		//Initializing category vector of length of the number of categories
		categories = new Category[numCats];
		
		//Initializing array of prior probabilities
		priorProbs = new double[numCats];
		
		//Initializing array of test classification
		testClassifications = new int[test.length];
		
		//Initializing each category object
		for(int i = 0; i < numCats; i++) {
			categories[i] = new Category();
		}
		
		//Private method to load files into categories
		loadDocs(labs, train);
		getPriors();
		classify(test);
	}
	
	private void classify(File[] docs) {
		try {
			//Calculating log weights 
			double[] weights = new double[numCats];
			
			//Getting prior probabilities on log scale
			for(int i = 0; i < weights.length; i++) {
				weights[i] = Math.log(priorProbs[i]);
			}
			
			//Reading in test documents, and classifying
			BufferedReader reader;
			for(int i = 1; i < docs.length; i++) {
				reader = new BufferedReader(new FileReader(docs[i]));
				String line = reader.readLine();
				while(line != null) {
					for(int j = 0; j < numCats; j++) {
						//Implementing the formula for each class probability
						weights[j] = weights[j] + Math.log(categories[j].getWordProb(line, alpha));
					}	
					//Continue reading until the end of the file
					line = reader.readLine();
				}
				
				//Maximum is the classification
				int classification = 0;
				for(int j = 1; j < numCats; j++) {
					if(weights[j] > weights[classification]) {
						classification = j;
					}
				}
				testClassifications[i] = classification;
			}
		} catch(Exception e) {
			System.out.println(e.getMessage());
		}
	}
	
	private void getPriors() {
		int totalDocs = 0;
		for(int i = 0; i < priorProbs.length; i++) {
			totalDocs = totalDocs + categories[i].totalDocs;
		}
		for(int i = 0; i < priorProbs.length; i++) {
			priorProbs[i] = ((double)categories[i].totalDocs)/((double)totalDocs);
		}
	}
	
	private void loadDocs(File labs, File[] train) {
		try {
			//Creating reader to read labels file
			BufferedReader reader = new BufferedReader(new FileReader(labs));
			
			//Keeping track of document index for 'train'
			int docIndex = 0;
			
			//Assumes each line of 'labs' contains exactly one character
			//which is the category number (plus one)
			
			//Reading first label from the file
			String line = reader.readLine();
			while(line != null) {
				//Parsing the category to an integer
				int cat = Integer.parseInt(line);
				
				//Adding the correct document to the correct category
				categories[cat-1].addDoc(train[docIndex]);
				
				//Reading the next label, and increasing index
				line = reader.readLine();
				docIndex++;
			}
			reader.close();
			
		} catch(Exception e) {
			System.out.println(e.getMessage());
		}
	}
}