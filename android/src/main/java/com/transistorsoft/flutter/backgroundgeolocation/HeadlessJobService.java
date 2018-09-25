package com.transistorsoft.flutter.backgroundgeolocation;

import android.annotation.TargetApi;
import android.app.job.JobParameters;
import android.app.job.JobService;
import android.os.Bundle;
import android.os.Handler;

import com.transistorsoft.locationmanager.logger.TSLog;

@TargetApi(21)
public class HeadlessJobService extends JobService {
    private HeadlessTask mHeadlessTask;

    final Handler mWorkHandler = new Handler();
    Runnable mWorkRunnable;

    @Override
    public boolean onStartJob(final JobParameters params) {
        final Bundle event = new Bundle(params.getExtras());

        mWorkRunnable = new Runnable() {
            @Override
            public void run() {
                mHeadlessTask = new HeadlessTask(getApplicationContext(), event, new HeadlessTask.Callback() {
                    @Override
                    public void onComplete() {
                        jobFinished(params, false);
                    }
                });
            }
        };
        mWorkHandler.post(mWorkRunnable);
        return true;
    }

    @Override
    public boolean onStopJob(JobParameters params) {
        mWorkHandler.removeCallbacks(mWorkRunnable);
        int hashCode = -1;
        if (mHeadlessTask != null) {
            hashCode = mHeadlessTask.hashCode();
        }
        TSLog.logger.debug(TSLog.ICON_WARN + " onStopJob: " + hashCode);
        jobFinished(params, false);
        return true;
    }
}