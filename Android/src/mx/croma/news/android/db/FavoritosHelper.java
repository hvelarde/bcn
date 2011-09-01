package mx.croma.news.android.db;

import java.util.ArrayList;
import java.util.List;

import mx.croma.news.android.core.Noticia;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class FavoritosHelper extends SQLiteOpenHelper {
	private static final int DB_VERSION = 1;
	private static final String DB_NAME = "cromanews";
	private static final String FAVORITOS_TABLE = "favoritos";
	private static final String CREATE_FAVORITOS_TABLE = "CREATE TABLE " + FAVORITOS_TABLE + " (" +
			"ID INTEGER PRIMARY KEY, " +
			"TITULO TEXT, " +
			"DESCRIPCION TEXT, " +
			"IMGURL TEXT, " +
			"FECHA TEXT, " +
			"LINK TEXT, " +
			"CATEGORIA TEXT)";
	public FavoritosHelper(Context context, String name, CursorFactory factory,
			int version) {
		super(context, name, factory, version);
	}
	
	public FavoritosHelper(Context context){
		super(context, DB_NAME, null, DB_VERSION);
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		Log.d("FavoritosDb", "Creando BD");
		db.execSQL(CREATE_FAVORITOS_TABLE);
		Log.d("FavoritosDb", "BD Creada");
	}
	
	public void agregaNoticia(Noticia noticia){
		ContentValues cv = new ContentValues();
		cv.put("TITULO", noticia.getTitulo());
		cv.put("DESCRIPCION", noticia.getDescripcion());
		cv.put("IMGURL", noticia.getImgUrl());
		cv.put("FECHA", noticia.getFecha());
		cv.put("LINK", noticia.getLink());
		cv.put("CATEGORIA", noticia.getCategoria());
		Log.d("FavoritosDb", "Insertando noticia");
		getWritableDatabase().insert(FAVORITOS_TABLE, null, cv);
		Log.d("FavoritosDb", "Noticia insertada");
	}
	
	public List<Noticia> getNoticias(){
		SQLiteDatabase database = getWritableDatabase();
		Cursor c = database.query(FAVORITOS_TABLE, null, null, null, null, null, null);
		Log.d("FavoritosDb", "Query exitoso");
		List<Noticia> favoritos = new ArrayList<Noticia>();
		while(c.moveToNext()){
			Log.d("FavoritosDb", "Obteniendo noticia");
			Noticia n = new Noticia();
			n.setCategoria(getVal(c, "CATEGORIA"));
			n.setDescripcion(getVal(c, "DESCRIPCION"));
			n.setFecha(getVal(c, "FECHA"));
			n.setImgUrl(getVal(c, "IMGURL"));
			n.setLink(getVal(c, "LINK"));
			n.setTitulo(getVal(c, "TITULO"));
			favoritos.add(n);
		}
		Log.d("FavoritosDb", "Cerrando cursor");
		c.close();
		database.close();
		return favoritos;
	}
	
	private String getVal(Cursor c, String column){
		return c.getString(c.getColumnIndex(column));
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		Log.d("FavoritosDb", "Llamando upgrade");
	}

}
