package com.cooper.sofaking;

import android.app.Activity;
import com.loopj.android.http.*;

import android.content.Intent;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;

import org.apache.http.Header;
import org.apache.http.client.HttpResponseException;

public class MainActivity extends Activity
{

    TextView tvDebug;
    Spinner spSofaSelector;
    Button butMoveToUp;
    Button butMoveToFeet;
    Button butMoveToFlat;
    Button butManUp;
    Button butManDown;
    private String DEBUG_TAG = "sofaKing";
    private static final int RESULT_SETTINGS = 1;
    private AsyncHttpClient client = new AsyncHttpClient();

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        PreferenceManager
                .getDefaultSharedPreferences(this);

        setContentView(R.layout.activity_main);

        tvDebug = (TextView) findViewById(R.id.debug_text_view);
        spSofaSelector = (Spinner) findViewById(R.id.spinner_sofa_selector);

        ArrayAdapter<String> spinnerArrayAdapter = new ArrayAdapter<String>(this, R.layout.spinner_item_text, getResources().getStringArray(R.array.sofa_arrays));
        spSofaSelector.setAdapter(spinnerArrayAdapter);

        butMoveToUp = (Button) findViewById(R.id.moveToUp);
        butMoveToFeet = (Button) findViewById(R.id.moveToFeet);
        butMoveToFlat = (Button) findViewById(R.id.moveToFlat);
        butManUp = (Button) findViewById(R.id.manUp);
        butManDown = (Button) findViewById(R.id.manDown);

        butMoveToUp.setOnClickListener(moveHandler);
        butMoveToFeet.setOnClickListener(moveHandler);
        butMoveToFlat.setOnClickListener(moveHandler);

        butManUp.setOnTouchListener(manualTouchHandler);
        butManDown.setOnTouchListener(manualTouchHandler);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        switch (item.getItemId())
        {

            case R.id.action_settings:
                Intent i = new Intent(this, SettingsActivity.class);
                startActivityForResult(i, RESULT_SETTINGS);
                break;

            case R.id.action_debug:
                if (tvDebug.getVisibility() == View.GONE)
                    tvDebug.setVisibility(View.VISIBLE);
                else
                    tvDebug.setVisibility(View.GONE);
                break;

            case R.id.action_stop_all:
                downloadWebPage(getBaseURL() + "/stopAll");
                break;

            case R.id.action_parental_mode:
                downloadWebPage(getBaseURL() + "/parentalMode");
                break;

            case R.id.action_crazy_mode:
                downloadWebPage(getBaseURL() + "/crazyMode");
                break;
        }

        return true;
    }

    View.OnClickListener moveHandler = new View.OnClickListener()
    {
        public void onClick(View view)
        {
            // Gets the URL from the UI's text field.
            String stringUrl = getBaseURL();

            switch (view.getId())
            {
                case R.id.moveToUp:
                    stringUrl += "/moveToUp/";
                    break;

                case R.id.moveToFeet:
                    stringUrl += "/moveToFeet/";
                    break;

                case R.id.moveToFlat:
                    stringUrl += "/moveToFlat/";
                    break;
            }

            stringUrl += spSofaSelector.getSelectedItemPosition();

            downloadWebPage(stringUrl);
        }
    };

    View.OnTouchListener manualTouchHandler = new View.OnTouchListener()
    {
        @Override
        public boolean onTouch(View view, MotionEvent event)
        {

            String stringUrl = getBaseURL();

            if (event.getAction() == MotionEvent.ACTION_DOWN)
            {

                switch (view.getId())
                {
                    case R.id.manUp:
                        stringUrl += "/manUpPress/";
                        break;

                    case R.id.manDown:
                        stringUrl += "/manDownPress/";
                        break;
                }

                stringUrl += spSofaSelector.getSelectedItemPosition();

                downloadWebPage(stringUrl);

            }
            else if (event.getAction() == MotionEvent.ACTION_UP)
            {

                switch (view.getId())
                {
                    case R.id.manUp:
                        stringUrl += "/manUpRelease/";
                        break;

                    case R.id.manDown:
                        stringUrl += "/manDownRelease/";
                        break;
                }

                stringUrl += spSofaSelector.getSelectedItemPosition();

                downloadWebPage(stringUrl);
            }

            return false;
        }
    };

    private void downloadWebPage(String url)
    {
        client.get(url, new AsyncHttpResponseHandler() {

            @Override
            public void onSuccess(int statusCode, Header[] headers, byte[] responseBody) {
                tvDebug.setText(String.valueOf(statusCode) + "\n" + new String(responseBody));
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, byte[] responseBody, Throwable error)
            {
                tvDebug.setText(String.valueOf(statusCode) + "\n" + String.valueOf(error.getMessage()));
            }
        });
    }

    private String getBaseURL()
    {
        return "http://" + PreferenceManager.getDefaultSharedPreferences(this).getString("prefIPAddress", "NULL");
    }
}