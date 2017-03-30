//This object stores words and their counts
public class Word {
	String word;
	int count;
	
	public Word(String w) {
		word = w;
		count = 1;
	}
	
	//The occurrence of the word increased for each insert
	public void addOccurence() {
		count = count + 1;
	}
 }
