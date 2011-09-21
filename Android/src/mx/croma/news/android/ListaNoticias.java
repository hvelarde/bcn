package mx.croma.news.android;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Calendar;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import mx.croma.news.android.core.CromaFeedHandler;
import mx.croma.news.android.core.CromaNewsAdapter;
import mx.croma.news.android.core.Noticia;
import mx.croma.news.android.core.NoticiaView;
import mx.croma.news.android.db.FavoritosHelper;
import mx.croma.news.android.object.Publicacion;

import org.xml.sax.SAXException;

import android.app.Activity;
import android.app.Dialog;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Html;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ViewGroup;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.ViewGroup.LayoutParams;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

public class ListaNoticias extends Activity {

	public static final long REFRESH_TIME = 60000;
	public static final String PREFS_NAME = "CromaNews_BCN_CACHE";
	
	private String _feedUrl;
	private ListView lv;
	private LinearLayout ll;
	TextView ntv;
	String istr ="";
	String icache ="";
	long cachedate;
	long nowdate;
	boolean created = false;
	private String categoria;

	@Override
	public void onCreate(Bundle savedInstance) {
		super.onCreate(savedInstance);
		setContentView(R.layout.lista_noticias);
		_feedUrl = getString(R.string.feed_prensa);
		lv = (ListView) findViewById(android.R.id.list);
		categoria = getIntent().getStringExtra("__categoria__");
		SetWaitMessage();
	}
	
	@Override
	public void onResume() {
		super.onResume();	
		if ("Favoritos".equals(categoria)) {
			CromaNewsAdapter newsAdapter = new CromaNewsAdapter(getFavoritos(), this);
		} else {
			AsyncDownloadParse adp = new AsyncDownloadParse(this,categoria,_feedUrl);
			if (!created) {
				adp.execute("");
				created = true;
			} else {
				if (!adp.UpToDate()) {
					SetUpdateMessage();
					ResetInterface();
					adp.execute("");
					created = true;	
				}
			}
			lv.setOnItemClickListener(new ListaListener());
		}
	}

	@Override
	public void onCreateContextMenu(ContextMenu menu, View v,
			ContextMenuInfo menuInfo) {
		if ("Favoritos".equals(categoria)) {
			NoticiaView view = (NoticiaView) v;
			Toast.makeText(ListaNoticias.this,
					"ID " + view.getNoticia().getId(), Toast.LENGTH_LONG)
					.show();
			Log.d("BCN", "Favorito: " + view.getNoticia().getId());
			return;
		}
		super.onCreateContextMenu(menu, v, menuInfo);
	}

	public ArrayList<Noticia> getFavoritos() {
		FavoritosHelper helper = new FavoritosHelper(this);
		return (ArrayList<Noticia>) helper.getNoticias();
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
	
	public void ResetInterface() {
		ViewGroup v = (ViewGroup) findViewById(android.R.id.list);
		v.removeViews(0, v.getChildCount());
		v.invalidate();
	}
	
	public void FinishedDownloadCallback(String categoria, CromaFeedHandler cfh) {
		CromaNewsAdapter newsAdapter;
		if (categoria.equalsIgnoreCase("Documentos")) {
			newsAdapter = new CromaNewsAdapter(Publicacion.class, cfh.getNoticias(), this);
		} else if(categoria.equalsIgnoreCase("Recientes")) {
			newsAdapter = new CromaNewsAdapter("", "RECIENTES",cfh.getNoticias(), this);
		} else {
			newsAdapter = new CromaNewsAdapter(categoria, "",cfh.getNoticias(), this);
		}
		lv.setOnItemClickListener(new ListaListener());
		lv.setAdapter(newsAdapter);	
		HideWaitMessage();
	}
	
	public void ErrorCallback(String key) {
		ErrorMessage();
	}
	
	public void SetWaitMessage() {
		ViewGroup parent = (ViewGroup) findViewById(R.id.llMessage);
		parent.setVisibility(0);
    	TextView ntv = (TextView) findViewById(R.id.tMessage);
    	ntv.setText(getString(R.string.dialog_downloading));
	}
	
	public void SetUpdateMessage() {
		ViewGroup parent = (ViewGroup) findViewById(R.id.llMessage);
		parent.setVisibility(0);
    	TextView ntv = (TextView) findViewById(R.id.tMessage);
    	ntv.setText(getString(R.string.dialog_updating));
	}
	
	public void HideWaitMessage() {
		ViewGroup parent = (ViewGroup) findViewById(R.id.llMessage);
		parent.setVisibility(8);
	}
	
	public void ErrorMessage() {
		ViewGroup parent = (ViewGroup) findViewById(R.id.llMessage);
		parent.setVisibility(8);
    	TextView ntv = (TextView) findViewById(R.id.tMessage);
		ntv.setText(getString(R.string.dialog_error));
	}
	
	

}
