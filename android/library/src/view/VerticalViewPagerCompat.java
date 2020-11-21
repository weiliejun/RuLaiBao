package view;

import android.database.DataSetObserver;
import android.support.v4.view.PagerAdapter;

public final class VerticalViewPagerCompat {
	private VerticalViewPagerCompat() {
	}

//	public interface DataSetObserver extends PagerAdapter.DataSetObserver {
//	}

	public static void setDataSetObserver(PagerAdapter adapter,
			DataSetObserver observer) {
		adapter.registerDataSetObserver(observer);
	}
}
