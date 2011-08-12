package mx.croma.news.android.object;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class PublicacionStorage {
	
	private static PublicacionStorage instance = new PublicacionStorage();
	private Map<String, List<Publicacion>> _mPublicaciones;
	
	private PublicacionStorage(){
		_mPublicaciones = new HashMap<String, List<Publicacion>>();
	}
	
	public static PublicacionStorage getInstance(){
		return instance;
	}
	
	public void addPublicacion(Publicacion p){
		List<Publicacion> publicaciones = _mPublicaciones.get(p.getTitulo());
		if(publicaciones == null){
			publicaciones = new LinkedList<Publicacion>();
		}
		publicaciones.add(p);
		_mPublicaciones.put(p.getTitulo(), publicaciones);
	}
	
	public List<Publicacion> getByCategory(String category){
		return _mPublicaciones.get(category);
	}
	
	public Map<String, List<Publicacion>> getAll(){
		return _mPublicaciones;
	}
	
	
}
