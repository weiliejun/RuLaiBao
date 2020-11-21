package com.rulaibao.uitls;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by junde on 2017/3/13.
 * 获取通讯录电话号码
 */

public class GetPhoneUtil {

    public static String[] getPhones(Activity activity, Intent data) {
        String[] phoneArray = null;
        if (data != null) {
            List<String> phoneList = new ArrayList<>();
            ContentResolver reContentResolverol = activity.getContentResolver();
            Uri contactData = data.getData();
            @SuppressWarnings("deprecation") Cursor cursor = activity.managedQuery(contactData, null, null, null, null);
            cursor.moveToFirst();     // 获取联系人的姓名
            try {
//                String username = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
                // 获取用户名Id
                String contactId = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts._ID));

                // 获得DATA表中的电话号码，条件为联系人ID,因为手机号码可能会有多个
                Cursor phone = reContentResolverol.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = " + contactId, null, null);

                while (phone.moveToNext()) {
                    // 获取联系人号码
                    String phoneStr = phone.getString(phone.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
                    phoneList.add(phoneStr);
                }

                int size = phoneList.size();
                if (size != 0) {
                    phoneArray = phoneList.toArray(new String[size]);
                }
            } catch (Exception e) {
                phoneArray = null;
            }
        }
        return phoneArray;
    }
}
