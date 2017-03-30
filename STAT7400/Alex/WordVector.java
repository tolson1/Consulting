//WordVector is used to store a collection of words in the hashtable

import java.util.Vector;

public class WordVector {
	Vector<Word> words;
	
	public WordVector() {
		words = new Vector<Word>();
	}
	
	//Add a word to the vector, or increase count if it already exists
	public void addWord(String w) {
		//If it is empty, automatically add new word
		if(words.size() == 0) {
			words.addElement(new Word(w));
		} else {
			//If word doesn't exist, add new one
			boolean exists = false;
			for(int i = 0; i < words.size(); i++) {
				//If word does exist, add the count by 1
				if(words.elementAt(i).word.equals(w)) {
					words.elementAt(i).addOccurence();
					exists = true;
					break;
				}
			}
			if(!exists) {
				words.addElement(new Word(w));
			}
		}
	}
	
	//Obtain the count of a particular word
	public int getWordCount(String w) {
		int count = 0;
		//If there are no words yet, return -1
		if(words.size() == 0) {
			return -1;
		} 
		//If 'w' is not in the vector, return 0
		for(int i = 0; i < words.size(); i++) {
			//If 'w' is in the vector, return its count
			if(words.elementAt(i).word.equals(w)) {
				count = words.elementAt(i).count;
				break;
			}
		}
		return count;
	}
}
