package tw.com.gmall.hotshoes.Config;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

public class HideSoftKeyboard {
    public void hideKeyboardHandler(View view, final Context context) {


        if (!(view instanceof EditText)) {

            view.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View view, MotionEvent motionEvent) {
                    hideSoftKeyboard(view, context);
                    return false;
                }
            });

        }else{
        }

    //If a layout container, iterate over children and seed recursion.
    if (view instanceof ViewGroup) {
        Log.d("msg","viewgroup");
        for (int i=0;i<((ViewGroup) view).getChildCount();i++) {
            View innerView = ((ViewGroup) view).getChildAt(i);
            hideKeyboardHandler(innerView, context);
        }
    }
}

    public void hideSoftKeyboard(View view, Context context) {
        InputMethodManager inputMethodManager =
                (InputMethodManager) context.getSystemService(Activity.INPUT_METHOD_SERVICE);
        inputMethodManager.hideSoftInputFromWindow(view.getRootView().getWindowToken(),0);
    }



}
