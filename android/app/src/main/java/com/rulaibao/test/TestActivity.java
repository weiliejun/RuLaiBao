package com.rulaibao.test;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.rulaibao.R;
import com.rulaibao.base.BaseActivity;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by xww on 2018/11/22
 **/
public class TestActivity extends BaseActivity {


    @BindView(R.id.et_input_one)
    EditText etInputOne;
    @BindView(R.id.et_input_two)
    EditText etInputTwo;
    @BindView(R.id.et_iput_three)
    EditText etIputThree;
    @BindView(R.id.et_input_one_v)
    EditText etInputOneV;
    @BindView(R.id.et_input_two_v)
    EditText etInputTwoV;
    @BindView(R.id.et_iput_three_v)
    EditText etIputThreeV;
    @BindView(R.id.btn_result)
    Button btnResult;
    @BindView(R.id.tv_result)
    TextView tvResult;
    @BindView(R.id.et_iput_four)
    EditText etIputFour;
    @BindView(R.id.et_iput_four_v)
    EditText etIputFourV;

    private float a1,a2,a3,a4,a5,a6,a7,a8;
    private int b;
    private int c;

    @Override
    public void initData() {

    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        baseSetContentView(R.layout.activity_test);
        ButterKnife.bind(this);

    }


    @OnClick(R.id.btn_result)
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_result:

                getResult();

                break;
        }


    }


    //1000 666 349 226 105 88 64
    public void getResult() {

        a1 = Float.parseFloat(etInputOne.getText().toString());
        a2 = Float.parseFloat(etInputTwo.getText().toString());
        a3 = Float.parseFloat(etIputThree.getText().toString());
        a4 = Float.parseFloat(etIputFour.getText().toString());
        a5 = Float.parseFloat(etInputOneV.getText().toString());
        a6 = Float.parseFloat(etInputTwoV.getText().toString());
        a7 = Float.parseFloat(etIputThreeV.getText().toString());
//        a8 = Float.parseFloat(etIputFourV.getText().toString());

        float result = a1*1000 + a2*666 +a3*349 + a4*226 + a5*105 + a6*88 + a7*64;
        tvResult.setText(String.valueOf(result));
    }

}
