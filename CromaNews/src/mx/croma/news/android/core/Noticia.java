package mx.croma.news.android.core;

import java.io.Serializable;

import android.graphics.drawable.Drawable;

@SuppressWarnings("serial")
public class Noticia implements Serializable{
	
	private String _titulo;
	private String _descripcion;
	private String _imgUrl;
	private String _fecha;
	private String _link;
	public Noticia(){
		
	}
	
	
	public void setTitulo(String titulo){
		_titulo = titulo;
	}
	
	public void setDescripcion(String descripcion){
		_descripcion = descripcion;
	}
	
	public void setImgUrl(String imgUrl){
		_imgUrl = imgUrl;
	}
	
	public void setFecha(String fecha){
		_fecha = fecha;
	}
	
	public String getTitulo(){
		return _titulo;
	}
	
	public String getDescripcion(){
		return _descripcion;
	}
	
	public String getImgUrl(){
		return _imgUrl;
	}
	
	public String getFecha(){
		return _fecha;
	}

	public void setLink(String _link) {
		this._link = _link;
	}

	public String getLink() {
		return _link;
	}
}
