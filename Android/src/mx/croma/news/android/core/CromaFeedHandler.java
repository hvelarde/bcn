package mx.croma.news.android.core;

import java.util.ArrayList;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

public class CromaFeedHandler extends DefaultHandler {

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
		if(cacheNoticias == null){
			cacheNoticias = _noticias;
		}
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
			if(attributes != null && _actual != null)
				_actual.setCategoria(attributes.getValue("term"));
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
				_noticias.add(_actual);
				onItem = false;
			}
		}
	}

}
