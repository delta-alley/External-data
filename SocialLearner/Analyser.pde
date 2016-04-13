public class Analyser{
  
    private HashMap<String,Integer> words = new HashMap<String,Integer>(); 
    String searchTerm;
    public Analyser(String searchTerm) {
      this.searchTerm = searchTerm;
    }
    
    public ArrayList<String> analyseText(String tweetText) {
        ArrayList<String> learnedWords = new ArrayList<String>();
        String[] wordsArray = tweetText.replace(",", "").split(" ");
        for (int i = 0; i < wordsArray.length; i++) {
            String word = wordsArray[i];
            if(words.containsKey(wordsArray[i])) {
                words.put(word,words.get(wordsArray[i])+1);
                if(words.get(word) == 30 && word.length() > 3 && !word.toLowerCase().equals(searchTerm.toLowerCase())) {
                    learnedWords.add(word);
                }
            }
            else {
                words.put(word, 1);
            }
        }
        return learnedWords;
    }
    
    public HashMap<String,Integer> getWords() {
        return words;
    }
  
}