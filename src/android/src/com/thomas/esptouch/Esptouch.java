package com.thomas.esptouch;

import android.os.AsyncTask;
import android.util.Log;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.List;

/**
 * Created by Thomas.Wang on 2017/6/13.
 */
public class Esptouch extends CordovaPlugin {
    private static final String TAG = "Esptouch";
    CallbackContext receivingCallbackContext = null;
    EspWifiAdminSimple mWifiAdmin;
    @Override
    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        receivingCallbackContext = callbackContext;//modified by lianghuiyuan
        if ("getWifiSSid".equals(action)){
            mWifiAdmin = new EspWifiAdminSimple(cordova.getActivity());
            String apSsid = mWifiAdmin.getWifiConnectedSsid();
            callbackContext.success(apSsid);
            return true;
        }else if ("startSearch".equals(action)) {
            final String apSsid = args.getString(0);
            final String apPassword = args.getString(1);
//            final String isSsidHiddenStr = args.getString(2);
            final String isSsidHiddenStr = "NO";
//            final String taskResultCountStr = args.getString(3);
            final String taskResultCountStr = "1";
//            final int taskResultCount = Integer.parseInt(taskResultCountStr);
            String apBssid = mWifiAdmin.getWifiConnectedBssid();
            new EsptouchAsyncTask3().execute(apSsid, apBssid, apPassword,
                    isSsidHiddenStr, taskResultCountStr);
            return true;
        } else if ("stopSearch".equals(action)) {
            stopSearch();
            callbackContext.success("停止配网");
            return true;
        } else{
            callbackContext.error("can not find the function "+action);
            return false;
        }
    }

    private IEsptouchTask mEsptouchTask;
    private final Object mLock = new Object();
    private void stopSearch(){
        synchronized (mLock) {
                if (mEsptouchTask != null) {
                    mEsptouchTask.interrupt();
                }
            }
    }

    private class EsptouchAsyncTask3 extends AsyncTask<String, Void, List<IEsptouchResult>> {
        // without the lock, if the user tap confirm and cancel quickly enough,
        // the bug will arise. the reason is follows:
        // 0. task is starting created, but not finished
        // 1. the task is cancel for the task hasn't been created, it do nothing
        // 2. task is created
        // 3. Oops, the task should be cancelled, but it is running

        @Override
        protected void onPreExecute() {
        }

        @Override
        protected List<IEsptouchResult> doInBackground(String... params) {
            int taskResultCount = -1;
            synchronized (mLock) {
                String apSsid = params[0];
                String apBssid = params[1];
                String apPassword = params[2];
                String isSsidHiddenStr = params[3];
                String taskResultCountStr = params[4];
                boolean isSsidHidden = false;
                if (isSsidHiddenStr.equals("YES")) {
                    isSsidHidden = true;
                }
                taskResultCount = Integer.parseInt(taskResultCountStr);
                mEsptouchTask = new EsptouchTask(apSsid, apBssid, apPassword,
                        isSsidHidden, cordova.getActivity());
            }
            List<IEsptouchResult> resultList = mEsptouchTask.executeForResults(taskResultCount);
            return resultList;
        }

        @Override
        protected void onPostExecute(List<IEsptouchResult> result) {

            IEsptouchResult firstResult = result.get(0);
            // check whether the task is cancelled and no results received
            if (!firstResult.isCancelled()) {
                int count = 0;
                // max results to be displayed, if it is more than maxDisplayCount,
                // just show the count of redundant ones
                final int maxDisplayCount = 5;
                // the task received some results including cancelled while
                // executing before receiving enough results
                if (firstResult.isSuc()) {
                    StringBuilder sb = new StringBuilder();
                    for (IEsptouchResult resultInList : result) {
                        sb.append("Esptouch success, bssid = "
                                + resultInList.getBssid()
                                + ",InetAddress = "
                                + resultInList.getInetAddress()
                                .getHostAddress() + "\n");
                        count++;
                        if (count >= maxDisplayCount) {
                            break;
                        }
                    }
                    if (count < result.size()) {
                        sb.append("\nthere's " + (result.size() - count)
                                + " more result(s) without showing\n");
                    }
                    receivingCallbackContext.success(sb.toString());
                } else {
                    receivingCallbackContext.error("配网超时");
                }
            }
        }
    }

}
