package mx.croma.news.android.object;

import mx.croma.news.android.core.Noticia;

@SuppressWarnings("serial")
public class Publicacion extends Noticia {
	
	private String _periodicidad;
	
	public Publicacion(){
		
	}
	
	public Publicacion(Noticia n){
		setDescripcion(n.getDescripcion());
		setFecha(n.getFecha());
		setImgUrl(n.getImgUrl());
		setLink(n.getLink());
		setTitulo(n.getTitulo());
	}

	public void setPeriodicidad(String periodicidad) {
		_periodicidad = periodicidad;
	}

	public String getPeriodicidad() {
		return _periodicidad;
	}
}
