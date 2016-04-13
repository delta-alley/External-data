import twitter4j.*;
import twitter4j.api.*;
import twitter4j.auth.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.util.*;
import twitter4j.util.function.*;

private Analyser analyser;
private ArrayList<String> searchTweets;
private ArrayList<String> learnedWords;
private Long lastMax = 0L;
private int tweetIndex = 0;
private int positionIndex = 0;
private String searchTerm = "brussels";
private float xPos = 100;
private float yPos = 20;
Twitter twitter;
void setup() {
  size(1366,800);
  background(0);
  learnedWords = new ArrayList<String>();
  analyser = new Analyser(searchTerm);
  twitter = twitterConfig();
  try{
    twitterGet(twitter);
  }
  catch(TwitterException t) {
  }
}

void draw() {
  String tweetText = searchTweets.get(tweetIndex);
  textSize(10);
  writeTweets(tweetText);
  learnedWords.addAll(analyser.analyseText(tweetText));
  for(int i = 0; i < learnedWords.size(); i++) {
    textSize(13);
    yPos = (i*20)+50;
    text(learnedWords.get(i), xPos, yPos);
  }
}

private void writeTweets(String tweetText) {
  if(positionIndex < 100) {
    int yPos = positionIndex*20;
    text(tweetText, 700,0+yPos);
    positionIndex++;
    tweetIndex++;
    delay(10);
    if(yPos >= height) {
      background(0);
      positionIndex = 0;
    }
    if(tweetIndex == searchTweets.size()) {
       try{
         twitterGet(twitter);
         tweetIndex=0;
       }
       catch(TwitterException t) { 
       }
    }
  }
}

private Twitter twitterConfig() {
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setDebugEnabled(true)
          .setOAuthConsumerKey("RSbgUKKUgROuwCfWTC1ItSf1b")
          .setOAuthConsumerSecret("hDSdZ0JSBAIct5Bc44J4PnVEftu88yef7AghcUdTo8uCZR652v")
          .setOAuthAccessToken("356983592-kcT7B1JRAUXOV90LGyDB4zgrbcer8QpLc1b40JnO")
          .setOAuthAccessTokenSecret("kYAGLrR6cE5aNNnH1rUSxw1mtSfLfXIr86JLFHTGbquKO");
  TwitterFactory tf = new TwitterFactory(cb.build());
  Twitter twitter = tf.getInstance();
  return twitter;
}

private void twitterGet(Twitter twitter) throws TwitterException {
  searchTweets = new ArrayList<String>();
  Query query = new Query(searchTerm+"-filter:retweets -filter:links");
  query.setLang("en");
  query.setCount(100);
  if(lastMax != 0) {
      query.setMaxId(lastMax);
  }
  QueryResult result = twitter.search(query);
  for (Status status : result.getTweets()) {
      searchTweets.add(status.getText().replace("\n", "").replace("\r", ""));
      lastMax = status.getId();
  }
}