package mx.croma.news.android.core;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import mx.croma.news.android.object.Publicacion;
import mx.croma.news.android.object.PublicacionStorage;
import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

public class CromaNewsAdapter extends BaseAdapter {

	private List<Noticia> _noticias;
	private Context _context;
	private String _category;
	
	public CromaNewsAdapter(ArrayList<Noticia> noticias, Context ctx){
		_noticias = noticias;
		_context = ctx;
	}
	
	public CromaNewsAdapter(String category, String filter, List<Noticia> noticias, Context ctx){
		Log.v("::::::VIA_CATEGORIA ",category);
		_noticias = noticias;
		_context = ctx;
		_category = category;
		_noticias = new ArrayList<Noticia>();
		for(Noticia n : noticias){
			String n_date = n.getFecha();
			Log.v(":::::::::DATE",n_date);
			if (filter.equalsIgnoreCase("RECIENTES")) {				
				if (IsRecent(n_date, 7)) {
					if (category!="") {
						if(_category.equals(n.getCategoria())){
							_noticias.add(n);
						}
					} else {
						_noticias.add(n);
					}
				}
			} else {
				if (category!="") {
					if(_category.equals(n.getCategoria())){
						_noticias.add(n);
					}
				} else {
					_noticias.add(n);
				}
			}
		}
	}
	
	public CromaNewsAdapter(Class<?> validClass, List<Noticia> noticias, Context ctx){
		Log.v("::::::VIA_CLASS ",validClass.toString());
		_context = ctx;
		_noticias = new ArrayList<Noticia>();
		if(validClass == Publicacion.class){
			Publicacion dummy;
			addToPublicacionStorage(noticias);
			for(String k : PublicacionStorage.getInstance().getAll().keySet()){
				dummy = new Publicacion();
				dummy.setTitulo(k);
				_noticias.add(dummy);
			}
			return;
		}
		for(Noticia n : noticias){
			if(validClass.isInstance(n)){
				_noticias.add(n);
			}
		}
	}
	
	private void addToPublicacionStorage(List<Noticia> noticias) {
		for(Noticia n : noticias){
			if(n instanceof Publicacion){
				Publicacion publicacion = (Publicacion)n;
				PublicacionStorage.getInstance().addPublicacion(publicacion);
			}
		}
	}

	public int getCount() {
		return _noticias.size();
	}

	public Object getItem(int arg0) {
		return _noticias.get(arg0);
	}

	public long getItemId(int arg0) {
		return arg0;
	}

	public View getView(int arg0, View arg1, ViewGroup arg2) {
		NoticiaView nv = null;
		if(arg1 == null){
			nv = new NoticiaView(_context, _noticias.get(arg0));
		}else{
			nv = (NoticiaView)arg1;
		}
		nv.update(_noticias.get(arg0));
		return nv;
	}
	
	public boolean IsRecent(String strdate, int TimeInDays) {
		boolean r = false;
		long d = TimeInDays * 24 * 60 * 60 * 1000; 
		Calendar t = Calendar.getInstance();
		Calendar h = Calendar.getInstance();
		t.set(Calendar.YEAR, Integer.parseInt(strdate.substring(0, 4)));
		t.set(Calendar.MONTH, Integer.parseInt(strdate.substring(5, 7)));
		t.set(Calendar.DATE, Integer.parseInt(strdate.substring(8, 10)));
		long delta = Math.abs(h.getTimeInMillis()-t.getTimeInMillis());
		if (delta>=d) {
			r = false;
		} else {
			Log.v("DATE::::::", "IsRecent "+strdate);
			r = true;
		}
		return r;
	}

}
