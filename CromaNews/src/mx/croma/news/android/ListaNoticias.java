package mx.croma.news.android;

import java.io.IOException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;

import mx.croma.news.android.core.CromaFeedHandler;
import mx.croma.news.android.core.CromaNewsAdapter;
import mx.croma.news.android.core.Noticia;
import android.app.ListActivity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.AdapterView.OnItemClickListener;

public class ListaNoticias extends ListActivity {
	
	private String _feedUrl;
	private ListView lv;
	@Override
	public void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
//		_feedUrl = getResources().getString(R.string.url_feed);
		_feedUrl = getIntent().getExtras().getString("_feed_");
		setContentView(R.layout.lista_noticias);
		 lv = (ListView)findViewById(android.R.id.list);
		CromaFeedHandler cfh = new CromaFeedHandler();
		SAXParserFactory spf = SAXParserFactory.newInstance();
		try {
			SAXParser sp = spf.newSAXParser();
			sp.parse(_feedUrl, cfh);
			lv.setAdapter(new CromaNewsAdapter(cfh.getNoticias(), this));
			lv.setOnItemClickListener(new ListaListener());
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private class ListaListener implements OnItemClickListener{
		public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
				long arg3) {
			Noticia n = (Noticia)lv.getItemAtPosition(arg2);
			Intent i = new Intent(getApplicationContext(), DetalleNoticia.class);
			i.putExtra("_noticia_", n);
			startActivity(i);
		}
		
	}
	

}
