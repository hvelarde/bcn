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

public class FacebookDialog extends Activity implements DialogListener {
	

	private static final String FACEBOOK_APP_ID = "269200169774179";
	private static final String FACEBOOK_APP_SECRET = "0283d79f9ce65eb6714aa33cffea3531";
	private Facebook facebookClient;
	String facebook_url = "";
	String facebook_title = "";
	boolean alreadyposted = false;

	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		super.onCreate(savedInstanceState);
		setContentView(R.layout.blank);
		(findViewById(R.id.d_Back)).setOnClickListener(lRegresar);
		InitializeContent();
    }	
	
    private OnClickListener lRegresar = new OnClickListener() {
		public void onClick(View v) {
            finish();
		}
    };
   
    public void InitializeContent(){
    	Bundle extras = getIntent().getExtras(); 
        if(extras !=null)
        {
        	if(extras.containsKey("facebook_url")) { facebook_url = extras.getString("facebook_url"); }	 
        	if(extras.containsKey("facebook_title")) { facebook_title = extras.getString("facebook_title"); }	  
        }        
        Facebook();
    }
    
    public void callbackSuccess() {
		String msg = getString(R.string.share_published);
		Toast myToast = Toast.makeText(getApplicationContext(), msg , Toast.LENGTH_SHORT);  
		myToast.show(); 
		finish();
    }
    
    public void callbackWrongLogin() {
		String msg = getString(R.string.share_wrong_id);
		Toast myToast = Toast.makeText(getApplicationContext(), msg , Toast.LENGTH_SHORT);  
		myToast.show(); 
		finish();
    }
    
    public void callbackError() {
		String msg = getString(R.string.share_not_published);
		Toast myToast = Toast.makeText(getApplicationContext(), msg , Toast.LENGTH_SHORT);  
		myToast.show();
		finish();
    }

    public void Facebook() {
    	
        try
        {
    	facebookClient = new Facebook(FACEBOOK_APP_ID);
        facebookClient.authorize(this,  new String[] {"publish_stream"}, this);
        } catch (Exception e) {
        	Log.v("FB POST EXCEPTION", e.toString());
        }

    }
	    
	public void onComplete(Bundle values) {
		Log.v("FACEBOOK","Completed");
		Log.v("FACEBOOK BUNDLE",values.toString());
		Log.v("FACEBOOK BUNDLE SIZE",values.size()+"");
		
		if(alreadyposted) { return; }
		
		if (values.isEmpty()) {
			Log.v("FACEBOOK","values empty");
			finish();
			return;   
        }
        if (!values.containsKey("post_id")) {
        	Log.v("FACEBOOK","has post_id");
            try {
                Bundle parameters = new Bundle();
                parameters.putString("link", facebook_url);
                parameters.putString("caption", facebook_title);
                facebookClient.dialog(this, "stream.publish", parameters, this);
                alreadyposted=true;
                
            } catch (Exception e) {
            	Log.v("FB POST EXCEPTION", e.toString());
                callbackError();
            }
        }	
	}

	public void onCancel() {
		Log.v("FACEBOOK","Canceled");
		finish();
	}


	public void onError(DialogError arg0) {
		Log.v("FACEBOOK","Error");
		callbackError();
	}

	public void onFacebookError(FacebookError arg0) {
		Log.v("FACEBOOK","FBError"); 
		callbackError();
	}

	
	    
	    
}
