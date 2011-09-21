package mx.croma.news.android.core;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import mx.croma.news.android.RecientesCache;
import mx.croma.news.android.object.Publicacion;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import android.util.Log;

public class CromaFeedHandler extends DefaultHandler {
	private SimpleDateFormat formatter =  new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
	private ArrayList<Noticia> _noticias;
	public static ArrayList<Noticia> cacheNoticias;
	private Noticia _actual;
	private String chars;
	private boolean onItem;

	private static final String TAG_ITEM = "entry", TAG_TITLE = "title",
			TAG_LINK = "link", TAG_DESCRIPTION = "content",
			TAG_DATE = "updated", TAG_CATEGORIA = "category";

	public CromaFeedHandler() {
		super();
	}

	public ArrayList<Noticia> getNoticias() {
		return _noticias;
	}

	@Override
	public void startDocument() {
		onItem = false;
		_noticias = new ArrayList<Noticia>();
	}

	@Override
	public void characters(char[] ch, int offset, int len) {
		if (onItem) {
			chars = new String(ch, offset, len);
		}
	}

	@Override
	public void startElement(String uri, String ln, String qName,
			Attributes attributes) {
		if (ln.endsWith(TAG_ITEM)) {
			onItem = true;
			_actual = new Noticia();
		} else if (ln.endsWith(TAG_LINK)) {
			if(attributes != null && _actual != null)
			_actual.setLink(attributes.getValue("href"));
		} else if(ln.endsWith("link")){
			if("enclosure".equals(attributes.getValue("rel"))){
				_actual.setImgUrl(attributes.getValue("href"));
			}
		} else if(ln.endsWith(TAG_CATEGORIA)){
			if(_actual instanceof Publicacion){
				Publicacion publicacion = (Publicacion)_actual;
				if(publicacion.getPeriodicidad() == null){
					publicacion.setPeriodicidad(attributes.getValue("term"));
				}else{
					publicacion.setCategoria(attributes.getValue("term"));
				}
				return;
			}
			if(attributes != null && _actual != null){
				_actual.setCategoria(attributes.getValue("term"));
			}
			if(_actual != null && "Documentos".equals(_actual.getCategoria())){
				Publicacion publicacion = new Publicacion(_actual);
				_actual = publicacion;
			}
		}
	}

	public void endElement(String uri, String ln, String qName) {
		if (onItem) {
			if (ln.endsWith(TAG_TITLE)) {
				_actual.setTitulo(chars);
			} else if (ln.endsWith(TAG_DESCRIPTION)) {
				_actual.setDescripcion(chars);
			} else if (ln.endsWith(TAG_DATE)) {
				_actual.setFecha(chars);
			} else if (ln.endsWith(TAG_ITEM)) {
				Log.v("BCN::", _actual.getFecha()+" "+_actual.getTitulo()+" "+_actual.getCategoria()+ " "+_actual.getClass().toString());
				_noticias.add(_actual);
				onItem = false;
			}
		}
	}

}
