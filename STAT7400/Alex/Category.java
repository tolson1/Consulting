import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

public class Category {
	WordTable table;
	int totalWords;
	int totalDocs;
	BufferedReader reader;
	
	public Category() {
		//Create new WordTable of arbitrary size
		table = new WordTable(10);
		
		//Upon initialization, no documents have been loaded
		totalWords = 0;
		totalDocs = 0;
	}
	
	//Returns the probability of a given word (nonparametric)
	public double getWordProb(String w, double alpha) {
		double count = (double)getWordCount(w);
		if(count == 0) {
			return (1-alpha)*(1/((double)totalWords));
		}
		return (alpha)*(count/((double)totalWords));
	}
	
	//Returns the count of a word
	public int getWordCount(String w) {
		return table.getWordCount(w);
	}
	
	//Input a file to be added to the category
	public void addDoc(File f) {
		try {
			reader = new BufferedReader(new FileReader(f));
			//Reading first line of file
			String line = reader.readLine();
			
			//Loop through file until the end
			while(line != null) {
				//Insert word into the WordTable
				table.insert(line);
				
				//Increase the number of words by 1
				totalWords = totalWords + 1;
				
				//Read next line
				line = reader.readLine();
			}
			reader.close();
			
			//After adding the entire document, increase count by one
			totalDocs = totalDocs + 1;
		} catch(Exception e) {
			System.out.println(e.getMessage());
		}
	}
}
