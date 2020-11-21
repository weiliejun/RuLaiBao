package com.rulaibao.uitls;


import android.app.Activity;
import android.content.Intent;

import com.rulaibao.activity.LoginActivity;
import com.rulaibao.activity.SalesCertificationActivity;
import com.rulaibao.activity.TrainingAnswerActivity;
import com.rulaibao.activity.TrainingAnswerDetailsActivity;
import com.rulaibao.activity.TrainingAskActivity;
import com.rulaibao.activity.TrainingAskDetailsActivity;
import com.rulaibao.activity.TrainingCircleActivity;
import com.rulaibao.activity.TrainingCircleDetailsActivity;
import com.rulaibao.activity.TrainingClassListActivity;
import com.rulaibao.activity.TrainingClassDetailsActivity;
import com.rulaibao.activity.TrainingIssueTopicActivity;
import com.rulaibao.activity.TrainingPromoteActivity;
import com.rulaibao.activity.TrainingSetAuthorityActivity;
import com.rulaibao.activity.TrainingToAskActivity;
import com.rulaibao.activity.TrainingTopicDetailsActivity;
import com.rulaibao.base.BaseActivity;
import com.rulaibao.test.TestActivity;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

/**
 * activity的开启以及activity的跳转管理
 */

public class RlbActivityManager {

    /**
     * 这个方法写的不知道有木有用☺
     *
     * @param activity    上下文
     * @param cls         activity的字节码文件
     * @param requestCode activity界面的请求状态码
     * @param maps        key-value存储类
     */
    public static void startActivityForResult(Activity activity, Class<? extends BaseActivity> cls, HashMap<String, Object> maps, int requestCode) {
        if (maps == null) return;
        Intent intent = new Intent(activity, cls);
        Set<String> keys = maps.keySet();
        for (String key : keys) {
            Object value = maps.get(key);
            if (value instanceof String) {
                intent.putExtra(key, (String) value);
            } else if (value instanceof Integer) {
                intent.putExtra(key, (Integer) value);
            } else if (value instanceof List) {
                intent.putExtra(key, (Serializable) value);
            } else {
                intent.putExtra(key, (Serializable) value);
            }
        }
        activity.startActivityForResult(intent, requestCode);
    }

    /**
     * @param activity 上下文
     * @param cls      activity的字节码文件
     */
    public static void startActivity(Activity activity, Class<? extends BaseActivity> cls) {
        Intent intent = new Intent(activity, cls);
        activity.startActivity(intent);
    }

    /**
     * 这个方法写的不知道有木有用☺
     *
     * @param activity 上下文
     * @param cls      activity的字节码文件
     * @param maps     参数的key-value hashmap集合
     */
    public static void startActivity(Activity activity, HashMap<String, Object> maps, Class<? extends BaseActivity> cls) {
        if (maps == null) return;
        Intent intent = new Intent(activity, cls);
        Set<String> keys = maps.keySet();
        for (String key : keys) {
            Object value = maps.get(key);
            if (value instanceof String) {
                intent.putExtra(key, (String) value);
            } else if (value instanceof Integer) {
                intent.putExtra(key, (Integer) value);
            } else if (value instanceof List) {
                intent.putExtra(key, (Serializable) value);
            } else {
                intent.putExtra(key, (Serializable) value);
            }
        }
        activity.startActivity(intent);
    }

    /**
     * @param activity 上下文
     * @param cls      activity的字节码文件
     */
    public static void startActivityAndFinish(Activity activity, Class<? extends BaseActivity> cls) {
        Intent intent = new Intent(activity, cls);
        activity.startActivity(intent);
        activity.finish();
    }

    /**
     * 这个方法写的不知道有木有用☺
     *
     * @param activity 上下文
     * @param cls      activity的字节码文件
     * @param maps     key-value存储类
     */
    public static void startActivityAndFinish(Activity activity, HashMap<String, Object> maps, Class<? extends BaseActivity> cls) {
        if (maps == null) return;
        Intent intent = new Intent(activity, cls);
        Set<String> keys = maps.keySet();
        for (String key : keys) {
            Object value = maps.get(key);
            if (value instanceof String) {
                intent.putExtra(key, (String) value);
            } else if (value instanceof Integer) {
                intent.putExtra(key, (Integer) value);
            } else if (value instanceof List) {
                intent.putExtra(key, (Serializable) value);
            } else {
                intent.putExtra(key, (Serializable) value);
            }
        }
        activity.startActivity(intent);
        activity.finish();
    }

    /************************************************ 研修模块start ***********************************************************/


    /**
     * 前往课程页面
     *
     * @param activity TrainingClassListActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingClassActivity(Activity activity, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, TrainingClassListActivity.class);
        } else {
            startActivity(activity, TrainingClassListActivity.class);
        }
    }

    /**
     * 前往问答页面
     *
     * @param activity TrainingAskActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingAskActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingAskActivity.class);
        } else {
            startActivity(activity, map, TrainingAskActivity.class);
        }
    }


    /**
     * 前往圈子页面
     *
     * @param activity TrainingCircleActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingCircleActivity(Activity activity, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, TrainingCircleActivity.class);
        } else {
            startActivity(activity, TrainingCircleActivity.class);
        }
    }


    /**
     * 前往展业页面
     *
     * @param activity TrainingPromoteActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingPromoteActivity(Activity activity, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, TrainingPromoteActivity.class);
        } else {
            startActivity(activity, TrainingPromoteActivity.class);
        }
    }


    /**
     * 前往课程详情
     *
     * @param activity TrainingClassDetailsActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingClassDetailsActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingClassDetailsActivity.class);
        } else {
            startActivity(activity, map, TrainingClassDetailsActivity.class);
        }
    }

    /**
     * 前往我要提问
     *
     * @param activity TrainingToAskActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingToAskActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingToAskActivity.class);
        } else {
            startActivity(activity, map, TrainingToAskActivity.class);
        }
    }

    /**
     * 前往问答详情
     *
     * @param activity TrainingAskDetailsActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingAskDetailsActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingAskDetailsActivity.class);
        } else {
            startActivity(activity, map, TrainingAskDetailsActivity.class);
        }
    }


    /**
     * 前往我要回答
     *
     * @param activity TrainingAnswerActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingAnswerActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingAnswerActivity.class);
        } else {
            startActivity(activity, map, TrainingAnswerActivity.class);
        }
    }


    /**
     * 前往回答详情
     *
     * @param activity TrainingAnswerDetailsActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingAnswerDetailsActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingAnswerDetailsActivity.class);
        } else {
            startActivity(activity, map, TrainingAnswerDetailsActivity.class);
        }
    }


    /**
     * 前往圈子详情主页
     *
     * @param activity TrainingCircleDetailsActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingCircleDetailsActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingCircleDetailsActivity.class);
        } else {
            startActivity(activity, map, TrainingCircleDetailsActivity.class);
        }
    }


    /**
     * 前往发布话题页面
     *
     * @param activity TrainingIssueTopicActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingIssueTopicActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingIssueTopicActivity.class);
        } else {
            startActivity(activity, map, TrainingIssueTopicActivity.class);
        }
    }


    /**
     * 前往话题详情页面
     *
     * @param activity TrainingTopicDetailsActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingTopicDetailsActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingTopicDetailsActivity.class);
        } else {
            startActivity(activity, map, TrainingTopicDetailsActivity.class);
        }
    }

    /**
     * 前往设置圈子权限页面
     *
     * @param activity TrainingSetAuthorityActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTrainingSetAuthorityActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, TrainingSetAuthorityActivity.class);
        } else {
            startActivity(activity, map, TrainingSetAuthorityActivity.class);
        }
    }


    /**
     * 前往登录页面
     *
     * @param activity LoginActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toLoginActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, LoginActivity.class);
        } else {
            startActivity(activity, map, LoginActivity.class);
        }
    }


    /**
     * 前往认证页面
     *
     * @param activity toSaleCertificationActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toSaleCertificationActivity(Activity activity, HashMap<String, Object> map, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, map, SalesCertificationActivity.class);
        } else {
            startActivity(activity, map, SalesCertificationActivity.class);
        }
    }

    /**
     * 前往测试页面
     *
     * @param activity toSaleCertificationActivity
     * @param isFinish 是否关闭当前页面  true  false
     */

    public static void toTestActivity(Activity activity, boolean isFinish) {
        if (isFinish) {
            startActivityAndFinish(activity, TestActivity.class);
        } else {
            startActivity(activity, TestActivity.class);
        }
    }

    /************************************************ 研修模块end ***********************************************************/


}
