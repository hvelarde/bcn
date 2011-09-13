package mx.croma.news.android;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.security.spec.EncodedKeySpec;

import org.apache.http.HttpConnection;
import org.xml.sax.InputSource;

import twitter4j.auth.AccessToken;
import mx.croma.news.android.core.CromaFeedLoader;
import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.view.View.OnLongClickListener;
import android.widget.EditText;
import android.view.View.OnClickListener;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

public class Registry extends Activity {
	
	int visitno = 0;
	public static final String PREFS_NAME = "CromaNews_BCN_Access";
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		InitializeVisitCount();
		if (visitno<2) {
			resetVisitNumber();
			Log.v("Visit Number", "FIRST TIME VISIT");
			setContentView(R.layout.registry);
			InitializeInterface();
		} else if (visitno==10) {
			Log.v("Visit Number", "TENTH VISIT");
			setContentView(R.layout.feedback);
			InitializeFeedbackInterface();
		} else {
			resetVisitNumber();
			Log.v("Visit Number", "Normal Visit");
			RegisterSuccesfulCallback();
		}
		
		
	}
	
	@Override
	public void onResume(){
		super.onResume();
		
	}
	
    private OnClickListener lDoreg = new OnClickListener() {
		public void onClick(View v) {
			String name = ((EditText)(findViewById(R.id.eName))).getText().toString();
			String mail = ((EditText)(findViewById(R.id.eMail))).getText().toString();
			if (ValidateValues(name, mail)) {
				DoRegister(name, mail);
			}	
		}
    };
    
    private OnClickListener lDontReg = new OnClickListener() {
		public void onClick(View v) {
			RegisterSuccesfulCallback();
		}
    };
    
    private OnLongClickListener __toFeedBack = new OnLongClickListener() {
		public boolean onLongClick(View arg0) {
	    	Intent myIntent = new Intent(getBaseContext(), Registry.class); 
	    	startActivityForResult(myIntent, 0);
	    	storeVisitNumber(10);
	    	Log.v("Visit Number Increased", visitno+" times");   
	    	finish();
			return false;
		}
    };
    
    private OnClickListener lDoFeed = new OnClickListener() {
		public void onClick(View v) {
			String name = ((EditText)(findViewById(R.id.eName))).getText().toString();
			String mail = ((EditText)(findViewById(R.id.eMail))).getText().toString();
			String country = ((EditText)(findViewById(R.id.eCountry))).getText().toString();
			String message =  ((EditText)(findViewById(R.id.eMessage))).getText().toString();
			if (ValidateValues(name, mail, country, message)) {
				DoFeedBack(name, mail, country, message);
			}	
		}
    };
    
    private void InitializeVisitCount() {
    	visitno = getVisitNumber();
    	Log.v("Visit Number", visitno+" times");   	
    }
    
    private void UpdateVisitNumber() {
    	visitno+=1;
    	storeVisitNumber(visitno);
    	Log.v("Visit Number Increased", visitno+" times");   
    }
    
    private void InitializeInterface() {
    	(findViewById(R.id.l_submit)).setOnClickListener(lDoreg);
    	(findViewById(R.id.l_dont)).setOnClickListener(lDontReg);
    	(findViewById(R.id.l_dont)).setOnLongClickListener(__toFeedBack);
    }
    
    private void InitializeFeedbackInterface() {
    	(findViewById(R.id.l_submit)).setOnClickListener(lDoFeed);
    	(findViewById(R.id.l_dont)).setOnClickListener(lDontReg);
    }
    
    private boolean ValidateValues(String name, String mail) {
    	boolean r = true;
    	if (name.length()<2) { 
    		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.registry_invalid_name) , Toast.LENGTH_LONG);  
			myToast.show();
			return false;
    	}
    	if ((mail.length()<2)) {
    		if ((mail.indexOf("@")==-1)) {
	    		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.registry_invalid_mail) , Toast.LENGTH_LONG);  
				myToast.show();
				return false;
    		}
    	}
    	return r;
    }
    
    private boolean ValidateValues(String name, String mail, String country, String message) {
    	boolean r = true;
    	if (name.length()<2) { 
    		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.registry_invalid_name) , Toast.LENGTH_LONG);  
			myToast.show();
			return false;
    	}
    	if ((mail.length()<2)) {
    		if ((mail.indexOf("@")==-1)) {
	    		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.registry_invalid_mail) , Toast.LENGTH_LONG);  
				myToast.show();
				return false;
    		}
    	}
    	if ((country.length()<2)) {
    		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.feedback_invalid_country) , Toast.LENGTH_LONG);  
			myToast.show();
			return false;
    	}
    	if ((message.length()<2)) {
    		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.feedback_invalid_message) , Toast.LENGTH_LONG);  
			myToast.show();
			return false;
    	}
    	return r;
    }
    
    private void DoRegister(String name, String mail) {
    	try {
			name = URLEncoder.encode(name, "UTF8");
			mail = URLEncoder.encode(mail, "UTF8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
    	
    	String regurl = getString(R.string.url_signup);
    	regurl += "?name=" + name + "&email=" + mail;
    	Log.v("URL SIGNUP ENCODED", regurl);
    	setWaitMessage();
    	CheckSimpleOkResponse okr = new CheckSimpleOkResponse(regurl);
    	okr.execute("regurl");
    }
    
    private void DoFeedBack(String name, String mail, String country, String message) {
    	try {
			name = URLEncoder.encode(name, "UTF8");
			mail = URLEncoder.encode(mail, "UTF8");
			country = URLEncoder.encode(country, "UTF8");
			message = URLEncoder.encode(message, "UTF8");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
    	
    	String regurl = getString(R.string.url_signup);
    	regurl += "?name=" + name + "&email=" + mail + "country=" + country + "&message=" + message;
    	Log.v("URL SIGNUP ENCODED FEEDBACK", regurl);
    	setWaitMessage();
    	CheckSimpleOkResponse okr = new CheckSimpleOkResponse(regurl);
    	okr.execute("regurl");
    }
    
    private void RegisterSuccesfulCallback() {
    	Intent myIntent = new Intent(getBaseContext(), Dashboard.class); 
    	startActivityForResult(myIntent, 0);
    	UpdateVisitNumber();
    	finish();
    }
    
    private void RegisterUnSuccesfulCallback() {
    	if (visitno!=10) {
    		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.registry_fail) , Toast.LENGTH_LONG);  
    		myToast.show(); 
    	} else {
    		UpdateVisitNumber();
    	}
    	Intent myIntent = new Intent(getBaseContext(), Dashboard.class); 
    	startActivityForResult(myIntent, 0);
    	finish();
    }
    
    private void storeVisitNumber(int visitno){
        SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = settings.edit();
        editor.putInt("visitno", visitno);
        editor.commit();
    }
    
    private void resetVisitNumber(){
        SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = settings.edit();
        editor.remove("visitno");
        editor.commit();
        visitno = 0;
    }
    
    private int getVisitNumber(){
		SharedPreferences settings = getSharedPreferences(PREFS_NAME, 0);
		return settings.getInt("visitno", 0);
   }
    
    public void setWaitMessage() {
    	(findViewById(R.id.l_dont)).setVisibility(8);
    	((TextView)findViewById(R.id.l_doreg)).setText(getString(R.string.registry_wait));
    	((TextView)findViewById(R.id.l_doreg)).setOnClickListener(null);
    }
    
	
    public class CheckSimpleOkResponse extends AsyncTask<String, Void, String> {
    	
    	InputSource mis;
    	String curl;
    	int success = 0;
    	
    	CheckSimpleOkResponse(String purl) {
    		curl = purl;
    	}
		
        protected String doInBackground(String... str) {
        	try {
        		URL url = new URL(curl);
        		URLConnection curl = url.openConnection();
        		curl.setReadTimeout(2000);
        		curl.setConnectTimeout(2000);
        		HttpURLConnection httpCurl = (HttpURLConnection) curl;
                int response = httpCurl.getResponseCode();
                if(response==HttpURLConnection.HTTP_OK) {
                	success = 1;
                	mis = new InputSource(url.openStream());
                	Log.v("LOGIN RESPONSE:::",StreamToString(mis.getByteStream()));
        		} else {
        			success = 0;
        		}

			} catch (IOException e) { 
			 	Log.v("LOGIN IO ERROR DOWNLOAD", e.toString());
			 	success = 0;
			} catch (Exception e) {
			 	Log.v("LOGIN GENERAL ERROR DOWNLOAD", e.toString());
			 	success = 0;
			}
            return "";
        }

        protected void onPostExecute(String result) {
        	if (success == 1) { RegisterSuccesfulCallback(); } 	
        	else { RegisterUnSuccesfulCallback(); }
        }
    }    
	
    public String StreamToString(InputStream is) {
		if (is != null) {
		    byte[] bytes = new byte[5000];
		    StringBuilder x = new StringBuilder();
		    int numRead = 0;
		    try {
				while ((numRead = is.read(bytes)) >= 0) {
				    x.append(new String(bytes, 0, numRead));
				    is.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
				Log.v("Error IO EXC JSON", e.toString());
				return "";
			} catch (Exception e) {
				e.printStackTrace();
				Log.v("Error Generic EXC JSON", e.toString());
				return "";
			}
		  
		  return x.toString();
		  //return "";
		}  else { 
			return "";
		}
    }
}
