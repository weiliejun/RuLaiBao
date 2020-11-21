package com.rulaibao.uitls;

import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.net.Uri;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.util.Base64;
import android.widget.Button;
import android.widget.TextView;

import com.rulaibao.R;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StringUtil {
    public static String MD5Encode(byte[] bytes) {
        StringBuffer hexString = new StringBuffer();
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(bytes);
            byte[] digest = md.digest();
            String text;
            for (int i = 0; i < digest.length; i++) {
                text = Integer.toHexString(0xFF & digest[i]);
                if (text.length() < 2) {
                    text = "0" + text;
                }
                hexString.append(text);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return hexString.toString();
    }

    public static String MD5Encode(String text) {
        return MD5Encode(text.getBytes());
    }

    public static String eregi_replace(String strFrom, String strTo, String strTarget) {
        String strPattern = "(?i)" + strFrom;
        Pattern p = Pattern.compile(strPattern);
        Matcher m = p.matcher(strTarget);
        if (m.find()) {
            return strTarget.replaceAll(strFrom, strTo);
        } else {
            return strTarget;
        }
    }

    public static boolean fromNet(String s) {
        if (TextUtils.isEmpty(s)) {
            return false;
        }
        return s.contains("http://") || s.contains("https://");
    }

    /**
     * 把手机号中间第4-7位用“*”号代替(11位手机号)
     *
     * @param str 要代替的字符串
     * @return
     */

    public static String replaceSubString(String str) {
        String sub = "";
        try {
            sub = str.substring(0, 3);
            String sub3 = str.substring(7, str.length());
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < 4; i++) {
                sb = sb.append("*");
            }
            sub = sub + sb.toString() + sub3;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sub;
    }
    /**
     * 将密码转为*号
     *
     * @param str 要代替的字符串
     * @return
     */

    public static String toXing(String str) {
        String sub = "";
        try {
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < str.length(); i++) {
                sb = sb.append("*");
            }
            sub = sb.toString() ;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sub;
    }

    /**
     * 把字符串的后n位用“*”号代替(11位手机号)
     *
     * @param str 要代替的字符串
     * @return
     */

    public static String replaceSubStringIdNo(String str) {
        String sub = "";
        try {
            sub = str.substring(0, 3);
            String sub3 = str.substring(14, str.length());
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < 11; i++) {
                sb = sb.append("*");
            }
            sub = sub + sb.toString() + sub3;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sub;
    }

    /**
     * 把字符串的后n位用“*”号代替(银行卡号)
     *
     * @param str 要代替的字符串
     * @return
     */

    public static String replaceSubStringBankCard(String str) {
        String sub = "";
        try {
            if (str.length() == 16) {
                String sub2 = str.substring(str.length() - 4, str.length());
                sub = "**** **** **** " + sub2;
            } else if (str.length() == 17) {
                String sub2 = str.substring(str.length() - 4, str.length());
                sub = "**** **** **** * " + sub2;
            } else if (str.length() == 19) {
                String sub2 = str.substring(str.length() - 4, str.length());
                sub = "**** **** **** *** " + sub2;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sub;
    }

    /**
     * 银行卡前后留四位
     *
     * @param bankNum
     * @return
     */
    public static String encryBankNum(String bankNum) {
        StringBuffer sb = new StringBuffer();
        sb.append(bankNum.substring(0, 4));
        sb.append(" **** **** ");
        sb.append(bankNum.substring(bankNum.length() - 4, bankNum.length()));

        return sb.toString();
    }

    /**
     * 把字符串的后n位用“*”号代替(只保留头尾两位)
     *
     * @param str 要代替的字符串
     * @return
     */

    public static String replaceSubStringName(String str) {
        String sub = "";
        try {
            sub = str.substring(0, 1);
            String sub3 = str.substring(str.length() - 1, str.length());
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < 4; i++) {
                sb = sb.append("*");
            }
            sub = sub + sb.toString() + sub3;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sub;
    }

    /***
     * 截取后 Length位
     *
     * @param str
     * @param length
     * @return
     */
    public static String subString(String str, int length) {
        String sub = "";
        try {
            if (str.length() > length) {
                sub = str.substring(length, str.length());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sub;
    }

    /**
     * 去除字符串中的特定字符
     *
     * @param str  原字符串
     * @param temp 需要去除的字符
     * @return
     */
    public static String subStringSpecial(String str, String temp) {
        String sub = str.replace(temp, "");
        return sub;
    }

    public static boolean isUserNameRight(String username) {
        Pattern p = Pattern.compile("^[a-zA-Z0-9\u4e00-\u9fa5]+$");
        Matcher m = p.matcher(username);
        if (m.matches()) {
            return true;
        }
        return false;

    }

    public static void sendSms(Context context, String phone, String body) {
        body = trimCRLF(body);
        Uri uri = Uri.parse("smsto:" + phone);
        Intent it = new Intent(Intent.ACTION_SENDTO, uri);
        it.putExtra("sms_body", body);
        context.startActivity(it);
    }

    /**
     * @param format "yyyy-MM-dd HH:mm:ss"
     * @param time
     * @return
     */
    public static String formatDate(String format, long time) {
        if (time != -1) {
            try {
                Date date = new Date(time);
                SimpleDateFormat sfd = new SimpleDateFormat(format/* "yyyy-MM-dd" */);
                return sfd.format(date);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return null;
    }

    /**
     * 多个连续换行符只留一个
     *
     * @param str
     * @return
     */
    public static String trimCRLF(String str) {
        if (str == null) {
            return null;
        }
        str = str.trim();
        str = str.replace("\r", "");
        char charc = '\0';
        char[] c = str.toCharArray();
        int l = c.length;
        int lrnSize = 0;
        for (int i = 0; i < l; i++) {
            if (c[i] == '\n') {
                lrnSize++;
            } else {
                lrnSize = 0;
            }
            if (lrnSize > 1) {
                c[i] = charc;
            }
        }
        // str = str.replace("\n", "");
        return new String(c);
    }

    /**
     * 判断是否为纯数字
     *
     * @param str 字符串
     * @return boolean类型
     */

    public static boolean isNumber(String str) {
        if (str.matches("[0-9]+")) return true;
        return false;
    }


    /**
     * 半角转全角
     *
     * @param input
     * @return
     */
    public static String ToDBC(String input) {
        char[] c = input.toCharArray();
        for (int i = 0; i < c.length; i++) {
            if (c[i] == 12288) {
                c[i] = (char) 32;
                continue;
            }
            if (c[i] > 65280 && c[i] < 65375) c[i] = (char) (c[i] - 65248);
        }
        return new String(c);
    }

    /**
     * 去掉url中的路径，留下请求参数部分
     *
     * @param strURL url地址
     * @return url请求参数部分
     */
    private static String truncateUrlPage(String strURL) {
        String strAllParam = null;
        String[] arrSplit = null;
        strURL = strURL.trim().toLowerCase();
        arrSplit = strURL.split("[?]");
        if (strURL.length() > 1) {
            if (arrSplit.length > 1) {
                if (arrSplit[1] != null) {
                    strAllParam = arrSplit[1];
                }
            }
        }
        return strAllParam;
    }

    /**
     * 解析出url参数中的键值对 如 "index.jsp?Action=del&id=123"，解析出Action:del,id:123存入map中
     *
     * @param URL url地址
     * @return url请求参数部分
     */
    public static Map<String, String> splitKeyValue(String URL) {
        Map<String, String> mapRequest = new HashMap<String, String>();
        String[] arrSplit = null;
        String strUrlParam = truncateUrlPage(URL);
        if (strUrlParam == null) {
            return mapRequest;
        }
        // 每个键值为一组
        arrSplit = strUrlParam.split("&");
        for (String strSplit : arrSplit) {
            String[] arrSplitEqual = null;
            arrSplitEqual = strSplit.split("=");
            // 解析出键值
            if (arrSplitEqual.length > 1) {
                // 正确解析
                mapRequest.put(arrSplitEqual[0], arrSplitEqual[1]);
            } else {
                if (arrSplitEqual[0] != "") {
                    // 只有参数没有值，不加入
                    mapRequest.put(arrSplitEqual[0], "");
                }
            }
        }
        return mapRequest;
    }

    public static String base64UrlEncode(String host, String url) {
        try {
            url = host + Base64.encodeToString(url.getBytes("utf-8"), Base64.NO_WRAP);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        // url = host + StringUtil.eregi_replace("(\r\n|\r|\n|\n\r)", "", url);
        return url;
    }

    // public static SpannableStringBuilder setStringStyle(){
    //
    // }

    /**
     * 验证手机格式
     */
    public static boolean isMobileNO(String mobiles) {
        /*移动号段：
        134 135 136 137 138 139 147 148 150 151 152 157 158 159 172 178 182 183 184 187 188 198
        联通号段：
        130 131 132 145 146 155 156 166 171 175 176 185 186
        电信号段：
        133 149 153 173 174 177 180 181 189 199
        虚拟运营商:
        170*/
        // String telRegex = "[1][34578]\\d{9}";//
        // "[1]"代表第1位为数字1，"[358]"代表第二位可以为3、5、8中的一个，"\\d{9}"代表后面是可以是0～9的数字，有9位。
        String telRegex = "^1[3456789]\\d{9}$";
        //       String telRegex = "^((166|198|199)|(14[5-8])|(15[^4])|(17[0-8])|((13|18)[0-9]))\\d{8}$";
        if (TextUtils.isEmpty(mobiles)) return false;
        else return mobiles.matches(telRegex);
    }

    /**
     * 验证邮政编码是否符合规则
     *
     * @param text 身份证号
     * @return
     */
    public static boolean zipCodeValidation(String text) {
        String regx = "[1-9]\\d{5}(?!\\d)";
        return text.matches(regx);
    }

    /***
     * 判断字符串中是否有空格
     *
     * @param str
     * @return
     */
    public static boolean hasBlank(String str) {
        if (str.startsWith(" ") || str.endsWith(" ")) {
            return true;
        } else {
            String s[] = str.split(" +");
            if (s.length == 1) {
                return false;
            } else {
                return true;
            }
        }
    }

    /**
     * 判断密码字符串中是否包含除_外特殊字符
     *
     * @param str
     * @return
     */
    public static boolean hasSpecialWord(String str) {
        boolean hasSymble = !str.matches("^[\\da-zA-Z_()!#$%^&*.~]*$");
        return hasSymble;
    }

    /**
     * 判断用户名字符串中是否包含除_外特殊字符
     *
     * @param str
     * @return
     */
    public static boolean hasSpecialWordUser(String str) {
        boolean hasSymble = !str.matches("^[\\da-zA-Z_]*$");
        return hasSymble;
    }

    /**
     * 密码是否是6-16位字母数字组合
     *
     * @param str
     * @return
     */
    public static boolean checkPassword(String str) {
        boolean hasSymble = str.matches("^(?![^a-zA-Z]+$)(?!\\D+$).[0-9a-zA-Z]{5,15}$");
        return hasSymble;
    }

    /***
     * 修改字符串样式
     *
     * @param context
     * @param str1
     * @param str2
     * @param str3
     * @param color1
     * @param color2
     * @param color3
     * @param size1
     * @param size2
     * @param size3
     * @param index1
     * @param index2
     * @param index3
     * @return
     */
    public static SpannableStringBuilder setTextStyle(Context context, String str1, String str2, String str3, int color1, int color2, int color3, int size1, int size2, int size3, int index1, int index2, int index3) {
        SpannableStringBuilder style = new SpannableStringBuilder(str3);
        // SpannableStringBuilder实现CharSequence接口
        style.setSpan(new AbsoluteSizeSpan(ViewUtils.sp2px(context, size1)), 0, str1.length() - index1, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        style.setSpan(new AbsoluteSizeSpan(ViewUtils.sp2px(context, size2)), str1.length() - index1, str2.length() - index2, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        style.setSpan(new AbsoluteSizeSpan(ViewUtils.sp2px(context, size3)), str2.length() - index2, str3.length() - index3, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        style.setSpan(new ForegroundColorSpan(context.getResources().getColor(color1)), 0, str1.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        style.setSpan(new ForegroundColorSpan(context.getResources().getColor(color2)), str1.length(), str2.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        style.setSpan(new ForegroundColorSpan(context.getResources().getColor(color3)), str2.length(), str3.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        return style;
    }

    /**
     * 将每三个数字加上逗号处理（通常使用金额方面的编辑）
     *
     * @param str
     * @return
     */
    public static String addComma(String str) {
        if (!TextUtils.isEmpty(str)) {
            String subEnd = "";
            String reverseStr = "";
            if (str.indexOf(".") != -1) {
                subEnd = str.substring(str.indexOf("."), str.length());
                // 将传进数字反转
                reverseStr = new StringBuilder(str.substring(0, str.indexOf("."))).reverse().toString();
            } else {
                subEnd = "";
                // 将传进数字反转
                reverseStr = new StringBuilder(str).reverse().toString();
            }


            String strTemp = "";
            for (int i = 0; i < reverseStr.length(); i++) {
                if (i * 3 + 3 > reverseStr.length()) {
                    strTemp += reverseStr.substring(i * 3, reverseStr.length());
                    break;
                }
                strTemp += reverseStr.substring(i * 3, i * 3 + 3) + ",";
            }
            // 将[789,456,] 中最后一个[,]去除
            if (strTemp.endsWith(",")) {
                strTemp = strTemp.substring(0, strTemp.length() - 1);
            }
            // 将数字重新反转
            String resultStr = new StringBuilder(strTemp).reverse().toString();
            return resultStr + subEnd;
        } else {
            return 0.00 + "";
        }

    }

    /**
     * 修改邀请排行按钮方法
     *
     * @param btn
     * @param mResource
     */
    public static void changeButtonStyle(Button btn_contacts, Button btn_invest, int btn, Resources mResource) {

//        if (btn == btn_contacts.getId()) {
//            btn_contacts.setBackgroundResource(R.color.white);
//            btn_contacts.setTextColor(mResource.getColor(R.color.orange));
//            btn_invest.setBackgroundResource(R.color.gray);
//            btn_invest.setTextColor(mResource.getColor(R.color.white));
//        } else if (btn == btn_invest.getId()) {
//            btn_contacts.setBackgroundResource(R.color.gray);
//            btn_contacts.setTextColor(mResource.getColor(R.color.white));
//            btn_invest.setBackgroundResource(R.color.white);
//            btn_invest.setTextColor(mResource.getColor(R.color.orange));
//        }

    }

    /**
     * 修改主页按钮方法
     *
     * @param btn
     * @param mResource
     */

    public static void changeButtonStyleZR(Button btn_wyk, Button btn_djk, int btn, Resources mResource) {

//        if (btn == btn_wyk.getId()) {
//            btn_wyk.setBackgroundResource(R.drawable.shape_left_blue_background);
//            btn_wyk.setTextColor(mResource.getColor(R.color.txt_white));
//            btn_djk.setBackgroundResource(R.drawable.shape_right_blue_two);
//            btn_djk.setTextColor(mResource.getColor(R.color.blue_two));
//        } else if (btn == btn_djk.getId()) {
//            btn_wyk.setBackgroundResource(R.drawable.shape_left_blue_two);
//            btn_wyk.setTextColor(mResource.getColor(R.color.blue_two));
//            btn_djk.setBackgroundResource(R.drawable.shape_right_blue_background);
//            btn_djk.setTextColor(mResource.getColor(R.color.txt_white));
//        }

    }

    /**
     * 验证string是否是正确的数字格式
     *
     * @param value
     * @return
     */
    public static boolean checkNumber(String value) {
        String regex = "^(-?[1-9]\\d*\\.?\\d*)|(-?0\\.\\d*[1-9])|(-?[0])|(-?[0]\\.\\d*)$";
        return value.matches(regex);
    }

    /**
     * 修改账本三个按钮方法
     *
     * @param btn
     * @param mResource
     */
    public static void changeButtonStyleThree(TextView btn_one, TextView btn_two, TextView btn_three, int btn, Resources mResource) {

        if (btn == btn_one.getId()) {
            btn_one.setBackgroundResource(R.drawable.shape_center_white);
            btn_one.setTextColor(mResource.getColor(R.color.bg_btn_orange));

            btn_two.setBackgroundResource(R.drawable.shape_center_light_gray);
            btn_two.setTextColor(mResource.getColor(R.color.gray_d));

            btn_three.setBackgroundResource(R.drawable.shape_center_light_gray);
            btn_three.setTextColor(mResource.getColor(R.color.gray_d));
        } else if (btn == btn_two.getId()) {
            btn_two.setBackgroundResource(R.drawable.shape_center_white);
            btn_two.setTextColor(mResource.getColor(R.color.bg_btn_orange));

            btn_one.setBackgroundResource(R.drawable.shape_center_light_gray);
            btn_one.setTextColor(mResource.getColor(R.color.gray_d));

            btn_three.setBackgroundResource(R.drawable.shape_center_light_gray);
            btn_three.setTextColor(mResource.getColor(R.color.gray_d));
        } else if (btn == btn_three.getId()) {
            btn_three.setBackgroundResource(R.drawable.shape_center_white);
            btn_three.setTextColor(mResource.getColor(R.color.bg_btn_orange));

            btn_two.setBackgroundResource(R.drawable.shape_center_light_gray);
            btn_two.setTextColor(mResource.getColor(R.color.gray_d));

            btn_one.setBackgroundResource(R.drawable.shape_center_light_gray);
            btn_one.setTextColor(mResource.getColor(R.color.gray_d));
        }

    }

    /**
     * 修改认购状态三个按钮方法
     *
     * @param btn
     * @param mResource
     */
    public static void changeButtonStyleRenGou(TextView btn_one, TextView btn_two, TextView btn_three, int btn, Resources mResource) {

        if (btn == btn_one.getId()) {
            btn_one.setTextColor(mResource.getColor(R.color.bg_btn_orange));

            btn_two.setTextColor(mResource.getColor(R.color.gray_d));

            btn_three.setTextColor(mResource.getColor(R.color.gray_d));
        } else if (btn == btn_two.getId()) {
            btn_two.setTextColor(mResource.getColor(R.color.bg_btn_orange));

            btn_one.setTextColor(mResource.getColor(R.color.gray_d));

            btn_three.setTextColor(mResource.getColor(R.color.gray_d));
        } else if (btn == btn_three.getId()) {
            btn_three.setTextColor(mResource.getColor(R.color.bg_btn_orange));

            btn_two.setTextColor(mResource.getColor(R.color.gray_d));

            btn_one.setTextColor(mResource.getColor(R.color.gray_d));
        }

    }

    /**
     * 验证是否属于与email格式
     *
     * @param strEmail
     * @return
     */
    public static boolean isEmail(String strEmail) {
        String strPattern = "^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$";

        Pattern p = Pattern.compile(strPattern);
        Matcher m = p.matcher(strEmail);
        return m.matches();
    }

}
