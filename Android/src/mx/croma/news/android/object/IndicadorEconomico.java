package mx.croma.news.android.object;

public class IndicadorEconomico {

	private String indicador;
	private String valor;
	private String fecha;
	
	public IndicadorEconomico(String indicador, String valor, String fecha){
		this.indicador=indicador;
		this.valor=valor;
		this.fecha=fecha;
	}
	
	public String getIndicador() {
		return indicador;
	}
	public void setIndicador(String indicador) {
		this.indicador = indicador;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	
	
	
	
}
