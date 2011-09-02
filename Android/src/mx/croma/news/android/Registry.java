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
		//resetVisitNumber();
		InitializeVisitCount();
		if (visitno<2) {
			Log.v("Visit Number", "FIRST TIME VISIT");
			setContentView(R.layout.registry);
			InitializeInterface();
		} else if (visitno==10) {
			Log.v("Visit Number", "TENTH VISIT");
			RegisterSuccesfulCallback();
		} else {
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
    }
    
    private boolean ValidateValues(String name, String mail) {
    	boolean r = true;
    	if (name.length()<2) { 
    		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.registry_invalid_name) , Toast.LENGTH_LONG);  
			myToast.show();
			r = false;
    	}
    	if ((mail.length()<2)) {
    		if ((mail.indexOf("@")==-1)) {
	    		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.registry_invalid_mail) , Toast.LENGTH_LONG);  
				myToast.show();
				r = false;
    		}
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
    
    private void RegisterSuccesfulCallback() {
    	Intent myIntent = new Intent(getBaseContext(), Dashboard.class); 
    	startActivityForResult(myIntent, 0);
    	UpdateVisitNumber();
    	finish();
    }
    
    private void RegisterUnSuccesfulCallback() {
		Toast myToast = Toast.makeText(getApplicationContext(), getString(R.string.registry_fail) , Toast.LENGTH_LONG);  
		myToast.show(); 
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
    	((TextView)findViewById(R.id.l_doreg)).setText(getString(R.string.registry_wait));
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
