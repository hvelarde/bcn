package mx.croma.news.android;

import java.util.ArrayList;

import mx.croma.news.android.core.Noticia;

public class RecientesCache {
	private static RecientesCache instance = new RecientesCache();
	private ArrayList<Noticia> recientes;
	public static RecientesCache getCache(){
		return instance;
	}
	private RecientesCache(){
		recientes = new ArrayList<Noticia>();
	}
	public ArrayList<Noticia> getRecientes(){
		return recientes;
	}
	public void emptyCache(){
		recientes = new ArrayList<Noticia>();
	}
}
