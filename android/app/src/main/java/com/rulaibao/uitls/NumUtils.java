package com.rulaibao.uitls;

/**
 * 数字格式验证
 * Created by hasee on 2016/11/9.
 */
public class NumUtils {

    //  判断是否是两位小数格式

    public static boolean isTwoDecimal(String d){

        boolean flag = false;
        flag = d.matches("^(?!0+(?:\\.0+)?$)(?:[1-9]\\d*|0)(?:\\.\\d{1,2})?$");

        return flag;

    }


    /**

     * 匹配Luhn算法：可用于检测银行卡卡号

     * @param cardNo

     * @return

     */

    public static boolean checkBankCard(String cardNo) {

        int[] cardNoArr = new int[cardNo.length()];
        for (int i=0; i<cardNo.length(); i++) {
            cardNoArr[i] = Integer.valueOf(String.valueOf(cardNo.charAt(i)));
        }
        for(int i=cardNoArr.length-2;i>=0;i-=2) {
            cardNoArr[i] <<= 1;
            cardNoArr[i] = cardNoArr[i]/10 + cardNoArr[i]%10;
        }
        int sum = 0;
        for(int i=0;i<cardNoArr.length;i++) {
            sum += cardNoArr[i];
        }
        return sum % 10 == 0;
    }

}
