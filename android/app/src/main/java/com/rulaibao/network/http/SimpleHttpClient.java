package com.rulaibao.network.http;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.rulaibao.uitls.encrypt.DESUtil;
import com.rulaibao.uitls.PreferenceUtil;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.cookie.BasicClientCookie;
import org.apache.http.protocol.HttpContext;

public class SimpleHttpClient extends AsyncHttpClient {
    public static final int RESULT_BYTE = 0;
    public static final int RESULT_STRING = 1;
    public static final int RESULT_HTTPENTITY = 2;

    private int responseCode = -1;
    /*
     * as this is a synchronous request this is just a helping mechanism to pass
     * the result back to this method. Therefore the result object has to be a
     * field to be accessible
     */
    protected Object result;
    protected Header[] mHeaders;
    protected int mType = -1;

    protected AsyncHttpResponseHandler responseHandler = null;
    protected Throwable exception = null;

    private Intent it;

    private Context c;

    public SimpleHttpClient(int resultType) {
        mType = resultType;
        if (resultType == RESULT_BYTE) {
            responseHandler = new BinaryHttpResponseHandler(null) {
                void sendResponseMessage(HttpResponse response) {
                    mHeaders = response.getAllHeaders();
                    super.sendResponseMessage(response);
                }

                protected void sendSuccessMessage(int statusCode, byte[] responseBody) {
                    responseCode = statusCode;
                    result = responseBody;
                }

                @Override
                protected void sendFailureMessage(Throwable e, byte[] responseBody) {
                    exception = e;
                }
            };
        } else if (resultType == RESULT_HTTPENTITY) {
            responseHandler = new HttpEntityResponseHandler() {
                public void onSuccess(int statusCode, Header[] headers, HttpEntity entity) {
                    mHeaders = headers;
                    result = entity;
                }

                public void onFailure(Throwable e, HttpEntity entity) {
                    exception = e;
                }

            };
        } else {
            responseHandler = new AsyncHttpResponseHandler() {

                protected void sendSuccessMessage(int statusCode, Header[] headers, String responseBody) {
                    mHeaders = headers;
                    responseCode = statusCode;
                    result = responseBody;
                }

                protected void sendFailureMessage(Throwable e, String responseBody) {
                    exception = e;
                }

                protected void sendFailureMessage(Throwable e, byte[] responseBody) {
                    exception = e;
                }

                protected void sendStartMessage() {
                }

                protected void sendFinishMessage() {
                }
            };
        }
    }

    public SimpleHttpClient(final Context c, int resultType) {
        this.c = c;
        mType = resultType;

        if (resultType == RESULT_BYTE) {
            responseHandler = new BinaryHttpResponseHandler(null) {
                void sendResponseMessage(HttpResponse response) {
                    mHeaders = response.getAllHeaders();
                    super.sendResponseMessage(response);
                }

                protected void sendSuccessMessage(int statusCode, byte[] responseBody) {
                    responseCode = statusCode;
                    result = responseBody;
                }

                @Override
                protected void sendFailureMessage(Throwable e, byte[] responseBody) {
                    exception = e;
                }
            };
        } else if (resultType == RESULT_HTTPENTITY) {
            responseHandler = new HttpEntityResponseHandler() {
                public void onSuccess(int statusCode, Header[] headers, HttpEntity entity) {
                    mHeaders = headers;
                    result = entity;
                }

                public void onFailure(Throwable e, HttpEntity entity) {
                    exception = e;
                }

            };
        } else {
            String cookie = null;
            try {
//                String activity = c.getClass().getSimpleName();
//                if (activity.equals("SignupActivity")) {
//                    cookie = PreferenceUtil.getCookie();
//                } else {
                    cookie = DESUtil.decrypt(PreferenceUtil.getCookie());
//                }

                this.addHeader("Cookie", cookie);
                PersistentCookieStore myCookieStore = new PersistentCookieStore(c);
                this.setCookieStore(myCookieStore);
                BasicClientCookie newCookie = new BasicClientCookie("JSESSIONID", cookie);
                myCookieStore.addCookie(newCookie);

            } catch (Exception e1) {
                e1.printStackTrace();
            }
            this.addHeader("cookies", cookie);

            responseHandler = new AsyncHttpResponseHandler() {
                protected void sendSuccessMessage(int statusCode, Header[] headers, String responseBody) {
                    mHeaders = headers;
                    responseCode = statusCode;
                    result = responseBody;
                    try {
                        if (result != null) {
                            String str = (String) result;
                            String data = DESUtil.decrypt(str);
                            Log.i("aaa", data);
                        } else {
                            Log.i("aaa", "result==========null");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }

                protected void sendFailureMessage(Throwable e, String responseBody) {
                    exception = e;
                }

                protected void sendFailureMessage(Throwable e, byte[] responseBody) {
                    exception = e;
                }

                protected void sendStartMessage() {
                }

                protected void sendFinishMessage() {
                }
            };
        }
    }

    /**
     * @return the response code for the last request, might be usefull
     * sometimes
     */
    public int getResponseCode() {
        return responseCode;
    }

    public Header[] getHeaders() {
        return mHeaders;
    }

    public Object getResult() {
        return result;
    }

    // Private stuff
    @Override
    protected void sendRequest(DefaultHttpClient client, HttpContext httpContext, HttpUriRequest uriRequest, String contentType, AsyncHttpResponseHandler responseHandler, Context context) {
        if (contentType != null) {
            uriRequest.addHeader("Content-Type", contentType);
        }

		/*
         * will execute the request directly
		 */
        new AsyncHttpRequest(client, httpContext, uriRequest, responseHandler).run();
    }

    public void delete(String url, RequestParams queryParams, AsyncHttpResponseHandler responseHandler) {
        // TODO what about query params??
        delete(url, responseHandler);
    }

    public void get(String url, RequestParams params) {
        this.get(url, params, responseHandler);
		/*
		 * the response handler will have set the result when this line is
		 * reached
		 */
    }

    public void get(String url) {
        this.get(url, null, responseHandler);
    }

    public void put(String url, RequestParams params) {
        this.put(url, params, responseHandler);
    }

    public void put(String url) {
        this.put(url, null, responseHandler);
    }

    public void post(String url, RequestParams params) {
        this.post(url, params, responseHandler);
    }

    public void post(String url) {
        this.post(url, null, responseHandler);
    }

    public void post(String url, HttpEntity entity) {
        this.post(c, url, entity, null, responseHandler);
    }

    public void delete(String url, RequestParams params) {
        this.delete(url, params, responseHandler);
    }

    public void delete(String url) {
        this.delete(url, null, responseHandler);
    }
}
