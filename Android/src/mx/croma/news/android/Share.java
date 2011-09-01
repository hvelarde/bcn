package mx.croma.news.android;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;

import org.json.JSONException;
import org.json.JSONObject;
import org.xml.sax.InputSource;

import com.facebook.android.DialogError;
import com.facebook.android.Facebook;
import com.facebook.android.Facebook.DialogListener;
import com.facebook.android.FacebookError;

import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;
import twitter4j.conf.Configuration;
import twitter4j.conf.ConfigurationBuilder;
//import twitter4j.http.AccessToken;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.TextView;
import android.widget.EditText;
import android.widget.Toast;

public class Share extends Activity {
	
	public static final String PREFS_NAME = "Persistent_Sharing";
	private static final String TWITTER_KEY = "tQM95vHrcjiCAkSJhC2rg";
	private static final String TWITTER_CONSUMER_SECRET_KEY = "W9Y6tdQUPgekCH6TpDjvkejite2WN2rVoQ8BENodRhs";
	private static final String FACEBOOK_APP_ID = "269200169774179";
	private static final String FACEBOOK_APP_SECRET = "0283d79f9ce65eb6714aa33cffea3531";
	private Facebook facebookClient;
	String accessToken = null;
	String accessSecretToken = null;
	String username = "";
	String password = "";
	String address = "";
	String mmsg = "";
	String content_url ="";
	String content_title ="";
	String sharing_method = "twitter";
	String twitter_token = "";
	String twitter_token_secret = "";
	RequestToken ActualRequestToken;
	String AcutalPin;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		InitalizeSavedOAuth();
		InitializeContent();
		InitializeInterface();
     
    }	
	
    private OnClickListener lLogout = new OnClickListener() {
		public void onClick(View v) {
			deleteAccessToken();
			finish();
		}
    };
	
    private OnClickListener lOAuth = new OnClickListener() {
		public void onClick(View v) {
			OAuthTweet();
		}
    };

    private OnClickListener lRegresar = new OnClickListener() {
		public void onClick(View v) {
            finish();
		}
    };
    
    private OnClickListener lPost = new OnClickListener() {
		public void onClick(View v) {
            Post();
		}
    };
    
    public void SharedDoneCallback() {
    	finish();
    }
    
    
    
    public void InitializeContent(){
    	Bundle extras = getIntent().getExtras(); 
        if(extras !=null)
        {
        	if(extras.containsKey("sharing_method")) { sharing_method= extras.getString("sharing_method"); }	
        	if(extras.containsKey("content_url")) { content_url = extras.getString("content_url"); }	 
        	if(extras.containsKey("content_title")) { content_title = extras.getString("content_title"); }	  

        }        
    }
    
    public void InitializeInterface() {
    	if (sharing_method.equalsIgnoreCase("twitter")) {
			setContentView(R.layout.twitter);
		    (findViewById(R.id.l_oauth)).setOnClickListener(lOAuth);
		    (findViewById(R.id.l_logout)).setOnClickListener(lLogout);
		    if (twitter_token == "" || twitter_token_secret == "") {
	        	((findViewById(R.id.lNotYetAuth))).setVisibility(0);
	        	((findViewById(R.id.lShareLogout))).setVisibility(8);
	        }
		}
		   
		if (sharing_method.equalsIgnoreCase("face")) {
			setContentView(R.layout.face);
		}
            
		if (sharing_method.equalsIgnoreCase("mail")) {
			setContentView(R.layout.mail);
		}

        ((EditText) findViewById(R.id.eMsg)).setText(content_title);
        ((TextView) findViewById(R.id.lurl)).setText(content_url);
        (findViewById(R.id.i_regresar)).setOnClickListener(lRegresar);       
        (findViewById(R.id.l_submit)).setOnClickListener(lPost);
        
        
    }
    
    public void InitalizeSavedOAuth() {
		SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
		twitter_token = settings.getString("twitterAccessToken", "");
		twitter_token_secret = settings.getString("twitterAccessTokenSecret", "");
		Log.v("tweet token", twitter_token);
		Log.v("tweet token secret", twitter_token_secret);
    }
    
    public void Post() {
    	if (sharing_method.equalsIgnoreCase("twitter")) {
    		Tweet();
    	}
    	if (sharing_method.equalsIgnoreCase("face")) {
    		Facebook();
    	}	    	
    	if (sharing_method.equalsIgnoreCase("mail")) {
    		Mail();
    	}
    }
    
    public void Mail() {
    	
    	String sSubject = ((TextView) findViewById(R.id.eSubject)).getText().toString();  	
    	String sMsg = ((TextView) findViewById(R.id.eMsg)).getText().toString();
    	mmsg= sMsg + " " + NoteWebAddress(content_url);
    	
    	final Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
        emailIntent.setType("plain/text");
        //emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, new String[] {address.getText().toString()});
        emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, new String[] {sSubject});
        emailIntent.putExtra(android.content.Intent.EXTRA_TEXT, mmsg);
        this.startActivity(Intent.createChooser(emailIntent, "Enviar Correo..."));
        SharedDoneCallback();
    }
	    
    public void OAuthTweet() {
    	try {		    	   
	    	    Twitter twitter = new TwitterFactory().getInstance();
	    	    twitter.setOAuthConsumer(TWITTER_KEY, TWITTER_CONSUMER_SECRET_KEY);
	    	    RequestToken requestToken = twitter.getOAuthRequestToken();
	    	    ActualRequestToken = requestToken;
	    	    Uri uriUrl = Uri.parse(requestToken.getAuthorizationURL());  
	    	    Intent launchBrowser = new Intent(Intent.ACTION_VIEW, uriUrl);  
	    	    startActivity(launchBrowser);
	    		} catch(Exception e) {
		    	   e.printStackTrace();
		    	   Log.v("tweet error", e.getMessage().toString());
	    	}
    }
	    
    public void Tweet() {
	    	
    	boolean posted = false;
    	String sTweet = ((TextView) findViewById(R.id.eMsg)).getText().toString();
    	String sPin = ((TextView) findViewById(R.id.ePin)).getText().toString();
    	mmsg= sTweet + " " + NoteWebAddress(content_url);
    	
    	if (twitter_token == "") {
    		try {		    	   
	    	    Twitter twitter = new TwitterFactory().getInstance();
	    	    twitter.setOAuthConsumer(TWITTER_KEY, TWITTER_CONSUMER_SECRET_KEY);
	    	    AccessToken accessToken = null;
	    	    while (null == accessToken) {
	    	      try{
	    	         if(sPin.length() > 0){
	    	           accessToken = twitter.getOAuthAccessToken(ActualRequestToken, sPin);
	    	         } else{
	    	           accessToken = twitter.getOAuthAccessToken();
	    	         }
	    	      } catch (TwitterException te) {
	    	          Log.v("Unable to get the access token.","");
	    	      }
	    	    }
	    	    storeAccessToken(twitter.verifyCredentials().getId() , accessToken);
	    	    
	    	    if (accessToken!=null){ 
		    	    Status status = twitter.updateStatus(mmsg);
		    	    posted = true;
	    	    }

    		} catch(Exception e) {
    		   posted = false;
	    	   e.printStackTrace();
	    	   Log.v("tweet error", e.getMessage().toString());
	    	}
    	} else {
    		try {		    	   
	    	    Twitter twitter = new TwitterFactory().getInstance();
	    	    twitter.setOAuthConsumer(TWITTER_KEY, TWITTER_CONSUMER_SECRET_KEY);
	    	    twitter.setOAuthAccessToken(loadAccessToken(0));    
	    	    Status status = twitter.updateStatus(mmsg);
	    	    posted = true;
    		} catch(Exception e) {
		    	   e.printStackTrace();
		    	   posted = false;
		    	   Log.v("tweet error", e.getMessage().toString());
			}
    	}
    	
    	
    		
    	String msg ="";
    	if (posted) {
    		msg = getString(R.string.share_published);
    		Toast myToast = Toast.makeText(getApplicationContext(), msg , Toast.LENGTH_SHORT);  
			myToast.show(); 
			SharedDoneCallback();
    	} else {
    		msg = getString(R.string.share_wrong_id);
    		Toast myToast = Toast.makeText(getApplicationContext(), msg , Toast.LENGTH_LONG);  
			myToast.show(); 
			//SharedDoneCallback();
    	}
	    		
    		 
    }
    
    public void Facebook() {
    	String sMsg = ((TextView) findViewById(R.id.eMsg)).getText().toString();  	
    	Intent myIntent = new Intent(this.getBaseContext(), FacebookDialog.class); 
    	myIntent.putExtra("facebook_url", content_url);
    	myIntent.putExtra("facebook_title", sMsg);
    	startActivityForResult(myIntent, 0);
    	finish();

    }
	    

    private void storeAccessToken(long l, AccessToken accessToken){
        SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = settings.edit();
        editor.putString("twitterAccessToken", accessToken.getToken());
        editor.putString("twitterAccessTokenSecret", accessToken.getTokenSecret());
        editor.commit();
    }
    
    private void deleteAccessToken(){
        SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = settings.edit();
        editor.remove("twitterAccessToken");
        editor.remove("twitterAccessTokenSecret");
        editor.commit();
        twitter_token="";
        twitter_token_secret="";
    }
    
    public AccessToken loadAccessToken(int useId){
        String token = twitter_token;
        String tokenSecret = twitter_token_secret;// load from a persistent store
        return new AccessToken(token, tokenSecret);
   }
	    
	    
    public String NoteWebAddress(String url) {
    	//String result = GetShortenedAddress(url);
    	return url;
    }
	    
    
	    
    public String StreamToString(InputStream is) throws IOException {
		if (is != null) {
		    byte[] bytes = new byte[10000];
		    StringBuilder x = new StringBuilder();
		    int numRead = 0;
		    try {
				while ((numRead = is.read(bytes)) >= 0) {
				    x.append(new String(bytes, 0, numRead));
				    is.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
				return "";
			}
		  
		  return x.toString();
		}  else { 
			return "";
		}
    }

	
	    
	    
}
