package mx.croma.news.android;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.Calendar;

import javax.xml.parsers.FactoryConfigurationError;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;

import mx.croma.news.android.core.CromaFeedHandler;
import android.app.Activity;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.util.Log;

public class AsyncDownloadParse extends AsyncTask<String, Void, String> {
	
	public static final long REFRESH_TIME = 60000;
	public static final int READ_TIMEOUT = 20000;
	public static final int CONN_TIME = 15000;
	public static final String PREFS_NAME = "CromaNews_BCN_CACHE";
	
	Activity mycontext;
	String catego;
	String myurl;
	InputStream is;
	String istr ="";
	String icache ="";
	long cachedate;
	long nowdate;
	CromaFeedHandler cfh = new CromaFeedHandler();
	SAXParserFactory spf = SAXParserFactory.newInstance();
	SAXParser sp;

	
	AsyncDownloadParse(Activity context, String categoria, String url) {
		Calendar c = Calendar.getInstance();
		nowdate = c.getTimeInMillis();
		mycontext = context;
		catego = categoria;
		myurl = url;
	}

	@Override
	protected String doInBackground(String... str) {
    	try {
    		if (UseCache()) {
    			if (icache!="") {
    				Log.v("USING CACHE", istr);
        			SAXParser parser = SAXParserFactory.newInstance().newSAXParser();
        			XMLReader xr = parser.getXMLReader();
        			xr.setContentHandler(cfh);
        			xr.parse(new InputSource(new ByteArrayInputStream(icache.getBytes())));
    			}
    		} else {
    			Log.v("NOT USING CACHE", "DOWNLOADING "+ myurl);
    			resetCache();
	    		URL url = new URL(myurl);
	    		URLConnection curl = url.openConnection();
	    		curl.setReadTimeout(READ_TIMEOUT);
	    		curl.setConnectTimeout(CONN_TIME);
	    		is = (InputStream) curl.getInputStream();  	  
	    		if (is!=null) {
	    			istr = StreamToString(is);
	    			if (istr!="") {
	    				Log.v("ISTR", istr);
	        			SAXParser parser = SAXParserFactory.newInstance().newSAXParser();
	        			XMLReader xr = parser.getXMLReader();
	        			xr.setContentHandler(cfh);
	        			xr.parse(new InputSource(new ByteArrayInputStream(istr.getBytes())));
	        			saveCache(istr);
	    			}
	    		} else {
	    			Log.v("ERROR DOWNLOADING", "NULL INPUTSTREAM"); 
	    			return "NULL_INPUTSTREAM";
	    		}
    		}
		} catch (IOException e) { 
		 	Log.v("ERROR IO", e.toString()); 
		 	return "ERROR_IO";
		} catch (ParserConfigurationException e2) {
			Log.v("ERROR SAX", e2.toString()); 
			e2.printStackTrace();
		} catch (SAXException e3) {
			Log.v("ERROR SAX", e3.toString()); 
			e3.printStackTrace();
		} catch (FactoryConfigurationError e4) {
			Log.v("ERROR SAX", e4.toString()); 
			e4.printStackTrace();
		}
		
        return "DONE";
	}
	
	protected void onPostExecute(String key) {
		if (key.equalsIgnoreCase("DONE")) {
			ListaNoticias ln = (ListaNoticias) mycontext;
			ln.FinishedDownloadCallback(catego, cfh);
		} else {
			ListaNoticias ln = (ListaNoticias) mycontext;
			ln.ErrorCallback(key);
		}
	}	
		
	public void saveCache(String str) {
		Calendar d = Calendar.getInstance();
		cachedate = d.getTimeInMillis();
		storeCacheData(str);
		storeCacheTime(cachedate);
		Log.v("SAVED CACHE", str.substring(0,20));
		Log.v("CACHE DATE", cachedate+"");
	}
	
	public String StreamToString(InputStream is) {
		String rstr = "";
		if (is != null) {
			BufferedReader r = new BufferedReader(new InputStreamReader(is));
			StringBuilder total = new StringBuilder();
			String line;
			try {
				while ((line = r.readLine()) != null) {
				    total.append(line);
				}
			} catch (IOException e) {
				return "";
			}
			rstr = total.toString();
		}  else { 
			return "";
		}
		return rstr;
    }
	
	public InputStream StringToStream(String s) {
		ByteArrayInputStream b = new ByteArrayInputStream(s.getBytes());
		return b;
	}
	
	public boolean UseCache() {
		boolean result = false;
		cachedate = getCacheTime();
		icache = getCacheData();
		Log.v("CACHE TIME AND DATA", cachedate + icache);
		Calendar c = Calendar.getInstance();
		nowdate = c.getTimeInMillis();
		if ((nowdate-cachedate)<REFRESH_TIME) { result = true; }
		if ((icache.length()<50)) { result = false; Log.v("SHORT CACHE; VOID", icache.length()+"chars");}
		Log.v("DELTA TIME", (nowdate-cachedate)+"s");
		return result;
	}
	
	public boolean UpToDate() {
		boolean result = false;
		cachedate = getCacheTime();
		Calendar c = Calendar.getInstance();
		nowdate = c.getTimeInMillis();
		if ((nowdate-cachedate)<REFRESH_TIME) { result = true; }
		Log.v("DELTA TIME", (nowdate-cachedate)+"s");
		return result;
	}
	
    private void storeCacheData(String data){
        SharedPreferences settings = mycontext.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = settings.edit();
        editor.putString("data", data);
        editor.commit();
    }
    
    private void storeCacheTime(long time){
        SharedPreferences settings = mycontext.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = settings.edit();
        editor.putFloat("time", time);
        editor.commit();
    }
    
    private void resetCache(){
        SharedPreferences settings = mycontext.getSharedPreferences(PREFS_NAME, 0);
        SharedPreferences.Editor editor = settings.edit();
        editor.remove("data");
        editor.remove("time");
        editor.commit();
    }
    
    private String getCacheData(){
		SharedPreferences settings = mycontext.getSharedPreferences(PREFS_NAME, 0);
		return settings.getString("data", "");
   }
    
    private long getCacheTime(){
		SharedPreferences settings = mycontext.getSharedPreferences(PREFS_NAME, 0);
		return (long) settings.getFloat("time", 0);
		
   }
	
}
