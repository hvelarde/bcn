package mx.croma.news.android;

import java.io.IOException;
import java.util.ArrayList;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import mx.croma.news.android.core.CromaFeedHandler;
import mx.croma.news.android.core.CromaNewsAdapter;
import mx.croma.news.android.core.Noticia;
import mx.croma.news.android.db.FavoritosHelper;
import mx.croma.news.android.object.Publicacion;

import org.xml.sax.SAXException;

import android.app.Dialog;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

public class ListaNoticias extends ListActivity {

	private String _feedUrl;
	private ListView lv;
	private static final int PROGRESS_DIALOG = 0;
	private ProgressDialog progressDialog;
	private ProgressThread progressThread;
	public int progress = 0;

	@Override
	public void onCreate(Bundle savedInstance) {
		super.onCreate(savedInstance);
		setContentView(R.layout.lista_noticias);
		_feedUrl = getResources().getString(R.string.feed_prensa);
		showDialog(PROGRESS_DIALOG);
		lv = (ListView) findViewById(android.R.id.list);
		String categoria = getIntent().getStringExtra("__categoria__");
		CromaNewsAdapter newsAdapter;
		try {
			if (CromaFeedHandler.cacheNoticias == null) {
				CromaFeedHandler cfh = new CromaFeedHandler();
				SAXParserFactory spf = SAXParserFactory.newInstance();
				progress = 10;
				SAXParser sp = spf.newSAXParser();
				progress = 20;
				sp.parse(_feedUrl, cfh);
				progress = 60;
				if ("Documentos".equals(categoria)) {
					newsAdapter = new CromaNewsAdapter(Publicacion.class, cfh
							.getNoticias(), this);
				} else if("Favoritos".equals(categoria)){
					newsAdapter = new CromaNewsAdapter(getFavoritos(), this);
				}else{
					newsAdapter = new CromaNewsAdapter(categoria, cfh
							.getNoticias(), this);
				}
			} else {
				if ("Documentos".equals(categoria)) {
					newsAdapter = new CromaNewsAdapter(Publicacion.class,
							CromaFeedHandler.cacheNoticias, this);
				}else if("Favoritos".equals(categoria)){ 
					newsAdapter = new CromaNewsAdapter(getFavoritos(), this);
				}else {
					newsAdapter = new CromaNewsAdapter(categoria,
							CromaFeedHandler.cacheNoticias, this);
				}
			}
			lv.setAdapter(newsAdapter);
			progress = 80;
			lv.setOnItemClickListener(new ListaListener());
			progress = 100;
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<Noticia> getFavoritos(){
		FavoritosHelper helper = new FavoritosHelper(this);
		return (ArrayList<Noticia>) helper.getNoticias();
	}

	protected Dialog onCreateDialog(int id) {
		switch (id) {
		case PROGRESS_DIALOG:
			progressDialog = new ProgressDialog(ListaNoticias.this);
			progressDialog.setMessage("Cargando...");
			progressDialog.setIndeterminate(true);
			progressThread = new ProgressThread(handler);
			progressThread.start();
			return progressDialog;
		default:
			return null;
		}
	}

	private class ListaListener implements OnItemClickListener {
		public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
				long arg3) {
			Noticia n = (Noticia) lv.getItemAtPosition(arg2);
			Intent i = new Intent(getApplicationContext(), DetalleNoticia.class);
			i.putExtra("_noticia_", n);
			startActivity(i);
		}

	}

	final Handler handler = new Handler() {
		public void handleMessage(Message msg) {
			int total = msg.getData().getInt("total");
			if (total >= 100) {
				dismissDialog(PROGRESS_DIALOG);
				progressThread.setState(ProgressThread.STATE_DONE);
			}
		}
	};

	/** Nested class that performs progress calculations (counting) */
	private class ProgressThread extends Thread {
		Handler mHandler;
		final static int STATE_DONE = 0;
		final static int STATE_RUNNING = 1;
		int mState;

		ProgressThread(Handler h) {
			mHandler = h;
		}

		public void run() {
			mState = STATE_RUNNING;
			// total = 0;
			while (mState == STATE_RUNNING) {
				try {
					Thread.sleep(100);
				} catch (InterruptedException e) {
					Log.e("ERROR", "Thread Interrupted");
				}
				Message msg = mHandler.obtainMessage();
				Bundle b = new Bundle();
				b.putInt("total", progress);
				msg.setData(b);
				mHandler.sendMessage(msg);
			}
		}

		/*
		 * sets the current state for the thread, used to stop the thread
		 */
		public void setState(int state) {
			mState = state;
		}
	}

}
