//Hashtable for the unique words in a Category/Document
public class WordTable {
		WordVector[] table;
		int size;
	
	//Arbitrary Hashtable size
	public WordTable(int size) {
		table = new WordVector[size];
		this.size = size;
		//Initializing the WordVector objects
		for(int i = 0; i <  size; i++) {
			table[i] = new WordVector();
		}
			
	}
	
	//Insert new word into table
	public void insert(String w) {
		table[hash(w)].addWord(w);
	}
	
	//Obtain the count for a given word
	public int getWordCount(String w) {
		return table[hash(w)].getWordCount(w);
	}
	
	//Determines index for word
	public int hash(String w) {
		int sum = 0;
		//Finds the remainder of the sum of the chars/size
		for(int i = 0; i < w.length(); i++) {
			sum = sum + w.charAt(i);
		}
		return sum%size;
	}
}
