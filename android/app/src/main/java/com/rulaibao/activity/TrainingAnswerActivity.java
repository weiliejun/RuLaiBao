package com.rulaibao.activity;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.bean.ResultInfoBean;
import com.rulaibao.network.BaseParams;
import com.rulaibao.network.BaseRequester;
import com.rulaibao.network.HtmlRequest;
import com.rulaibao.widget.TitleBar;

import java.util.LinkedHashMap;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 回答
 */

public class TrainingAnswerActivity extends BaseActivity {


    @BindView(R.id.tv_answer_title)
    TextView tvAnswerTitle;
    @BindView(R.id.et_answer_content)
    EditText etAnswerContent;
    @BindView(R.id.btn_training_answer)
    Button btnTrainingAnswer;
    @BindView(R.id.ll_training_answer)
    LinearLayout llTrainingAnswer;
    private String questionId = "";
    private String title = "";

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_training_answer);
        initTopTitle();
        initView();
    }

    public void initView() {

        questionId = getIntent().getStringExtra("questionId");
        title = getIntent().getStringExtra("title");
        tvAnswerTitle.setText(title);
    }

    private void initTopTitle() {
        TitleBar title = (TitleBar) findViewById(R.id.rl_title);
        title.setTitle(getResources().getString(R.string.title_null)).setLogo(R.mipmap.logo, false)
                .setIndicator(R.mipmap.icon_back).setCenterText(getResources().getString(R.string.training_answer))
                .showMore(false).setOnActionListener(new TitleBar.OnActionListener() {
            @Override
            public void onMenu(int id) {
            }

            @Override
            public void onBack() {
                finish();
            }

            @Override
            public void onAction(int id) {

            }
        });
    }

    //回答
    public void requestAnswer(String answerContent) {
//        ArrayMap<String,Object> map = new ArrayMap<String,Object>();
        LinkedHashMap<String, Object> map = new LinkedHashMap<String, Object>();
        map.put("userId", userId);
        map.put("questionId", questionId);
        map.put("answerContent", answerContent);

        btnTrainingAnswer.setClickable(false);

        HtmlRequest.getTrainingToAnswer(this, map, new BaseRequester.OnRequestListener() {
            @Override
            public void onRequestFinished(BaseParams params) {

                if (params.result != null) {

                    ResultInfoBean b = (ResultInfoBean) params.result;
                    if (b.getFlag().equals("true")) {
                        Toast.makeText(TrainingAnswerActivity.this, b.getMessage(), Toast.LENGTH_SHORT).show();
                        finish();
                    } else {
                        Toast.makeText(TrainingAnswerActivity.this, b.getMessage(), Toast.LENGTH_SHORT).show();

                    }

                } else {

                }
                btnTrainingAnswer.setClickable(true);
            }
        });

    }

    @OnClick(R.id.btn_training_answer)
    public void onClick() {
        requestAnswer(etAnswerContent.getText().toString());
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}
