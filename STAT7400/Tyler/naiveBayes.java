import java.io.*;
import java.util.*;

public class naiveBayes {
  public static void main (String[] args) throws FileNotFoundException {
      /* Location will be the one parameter passed from R that is provided by the user */
      String location = "C:/Users/Tyler Olson/Desktop/CIS Project";
      
      /* The training directory will automatically be found within the provided location */
      File training = new File("C:/Users/Tyler Olson/Desktop/CIS Project" + "/Training");
      
      /* Each subdirectory within the training folder will contain the documents corresponding 
       * to each of the classes/categories. For example, if the user was interested in classifying
       * documents as spam or not spam, there would be two subdirectories present: "Spam" and 
       * "Not Spam". The custom FilenameFilter below only identifies subdirectories and ignores
       * all other files.*/
      String[] labels = training.list(new FilenameFilter() {
        @Override
        public boolean accept(File current, String name) {
          return new File(current, name).isDirectory();
        }
      });
      
      /* A list will be used to store the hashmaps for the categories.*/
      List<Map<String, Integer>> categories = new ArrayList<Map<String, Integer>>();
      
      /* Iterating through each subdirectory/label... */
      for (String l: labels) {
        
        /* Initialize a new hashmap for each label */
        Map<String, Integer> map = new HashMap<String, Integer>();
        
        /* Access all of the individual documents within the subdirectory */
        File document = new File(location + "/Training" + "/" + l);
        File[] documents = document.listFiles();
        
        /* Iterating through these individual documents... */
        for(File d: documents) {
          Scanner sc = new Scanner(d);
          
          /* Instead of using a bufferedReader to read line by line, which would improve
           * the computational speed, I stuck with a basic scanner for the sake of 
           * simplicity. */
          while (sc.hasNext()) {
            String word = sc.next();
            
              /* If the hashmap already contains the word as a key, the count/
               * number of occurrences needs to be incremented by one. */
              if(map.containsKey(word)) {
                Integer count = (Integer)map.get(word);
                map.put(word, new Integer(count.intValue() + 1));
              }
              /* If the word is new, the new key along with an inital count of 
               * one should be added to the hashmap. */
              else {
                map.put(word, new Integer(1));
              }
          }
          sc.close();
        }
        
        /* The hashmap for a particular category is lastly added to the list. */
        categories.add(map);
      }
      
      /* This portion of the code is just to ensure the hashmaps are correct. */
      ArrayList<String> vocab = new ArrayList<String>(categories.get(0).keySet());
      Collections.sort(vocab);
      for (int i = 0; i < vocab.size(); i++) {
        String key = (String)vocab.get(i);
        Integer count = (Integer)categories.get(0).get(key);
        System.out.println(key + ", " + count);
      }
  }
}
      