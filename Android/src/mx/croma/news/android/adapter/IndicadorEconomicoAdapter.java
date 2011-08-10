package mx.croma.news.android.adapter;

import java.util.List;

import mx.croma.news.android.R;
import mx.croma.news.android.object.IndicadorEconomico;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

public class IndicadorEconomicoAdapter extends ArrayAdapter<IndicadorEconomico>{

	private List<IndicadorEconomico> indicadoresEconomicos;
	
	private Context context;
	public IndicadorEconomicoAdapter(Context context, int textViewResourceId,List<IndicadorEconomico> list) {
		super(context, textViewResourceId,list);
		this.indicadoresEconomicos=list;
		this.context=context;
	}
	
	public View getView(int position,View convertView,ViewGroup parent){
		if(convertView==null){
			LayoutInflater inflater=(LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView=inflater.inflate(R.layout.indicador_economico_item, null);
			
		}
		
		IndicadorEconomico indicadorEconomico=indicadoresEconomicos.get(position);
		TextView textIndicador=(TextView)convertView.findViewById(R.id.textIndicador);
		textIndicador.setText(indicadorEconomico.getIndicador());
		TextView textValor=(TextView)convertView.findViewById(R.id.textValor);
		textValor.setText(indicadorEconomico.getValor());
		TextView textFecha=(TextView)convertView.findViewById(R.id.textFecha);
		textFecha.setText(indicadorEconomico.getFecha());
		
		return convertView;
		
	}

}
