package mx.croma.news.android.core;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

public class CromaNewsAdapter extends BaseAdapter {

	private ArrayList<Noticia> _noticias;
	private Context _context;
	private String _category;
	
	public CromaNewsAdapter(ArrayList<Noticia> noticias, Context ctx){
		_noticias = noticias;
		_context = ctx;
	}
	
	public CromaNewsAdapter(String category, ArrayList<Noticia> noticias, Context ctx){
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
