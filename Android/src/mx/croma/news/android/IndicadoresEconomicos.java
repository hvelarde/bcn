package mx.croma.news.android;

import java.util.ArrayList;
import java.util.List;

import mx.croma.news.android.adapter.IndicadorEconomicoAdapter;
import mx.croma.news.android.graphics.AChartEngineSampleActivity;
import mx.croma.news.android.graphics.BarChartSample;
import mx.croma.news.android.object.IndicadorEconomico;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;

public class IndicadoresEconomicos extends ListActivity {

	private IndicadorEconomicoAdapter adapter;

	@Override
	public void onCreate(Bundle bundle) {
		super.onCreate(bundle);
		setContentView(R.layout.indicadores_economicos);

		List<IndicadorEconomico> indicadorEconomico = new ArrayList<IndicadorEconomico>();
		indicadorEconomico.add(new IndicadorEconomico("Tipo de Cambio",
				"2.94%", "08/11"));
		indicadorEconomico.add(new IndicadorEconomico("Inflacion Acumulada",
				"2.94%", "08/11"));
		indicadorEconomico.add(new IndicadorEconomico(
				"Reservas Brutas Cobertura RIB/BM", "3.62%", "06/11"));
		indicadorEconomico.add(new IndicadorEconomico(
				"Tasa efectiva de Encaje Diaria ME", "21.2%", "17/08/11"));
		indicadorEconomico.add(new IndicadorEconomico(
				"Tasa efectiva de Encaje Diaria MN", "18.6%", "17/08/11"));
		indicadorEconomico.add(new IndicadorEconomico(
				"OMAS", "", ""));

		adapter = new IndicadorEconomicoAdapter(this,
				R.layout.indicador_economico_item, indicadorEconomico);

		setListAdapter(adapter);

		getListView().setOnItemClickListener(new OnItemClickListener() {

			public void onItemClick(AdapterView<?> arg0, View arg1,
					int position, long arg3) {
				Log.d("BCN", "Entering on the tap");
				if (position == 1) {
					Intent intent = new Intent(IndicadoresEconomicos.this,
							AChartEngineSampleActivity.class);

					startActivity(intent);
				}else if(position==5){
					Intent intent = new Intent(IndicadoresEconomicos.this,
							BarChartSample.class);

					startActivity(intent);
					
				}
				

			}

		});

	}
}
