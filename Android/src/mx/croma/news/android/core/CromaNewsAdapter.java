package mx.croma.news.android.core;

import java.util.ArrayList;
import java.util.List;

import mx.croma.news.android.object.Publicacion;
import mx.croma.news.android.object.PublicacionStorage;

import android.content.Context;
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
	
	public CromaNewsAdapter(String category, List<Noticia> noticias, Context ctx){
		_noticias = noticias;
		_context = ctx;
		if(category != null){
			_category = category;
			_noticias = new ArrayList<Noticia>();
			for(Noticia n : noticias){
				if(_category.equals(n.getCategoria())){
					_noticias.add(n);
				}
			}
		}
	}
	
	public CromaNewsAdapter(Class<?> validClass, List<Noticia> noticias, Context ctx){
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

}
