package com.rulaibao.network;


public abstract class MyAsyncTask extends ParallelAsyncTask<Void, Integer, Object> {

    private BaseParams mParams;

    public MyAsyncTask(BaseParams params) {
        mParams = params;
    }

    @Override
    protected Object doInBackground(Void... params) {
        BaseParams p = mParams;
        if (!isCancelled()) {
            return doTask(p);
        }
        return null;
    }

    public void onPostExecute(Object Result) {
        onPostExecute(Result, mParams);
    }

    protected void onCancelled() {
    }

    public abstract Object doTask(BaseParams params);

    public abstract void onPostExecute(Object Result, BaseParams params);
}
