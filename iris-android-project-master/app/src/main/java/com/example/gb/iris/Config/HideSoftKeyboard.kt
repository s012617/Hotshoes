package com.example.gb.iris.Config

import android.app.Activity
import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.widget.EditText

fun hideKeyboardHandler(view: View, context: Context) {
    // Set up touch listener for non-text box views to hide keyboard.
    if (view !is EditText) {
        view.setOnTouchListener { view, event ->
            hideSoftKeyboard(view, context)
            false
        }
    }
    //If a layout container, iterate over children and seed recursion.
    if (view is ViewGroup) {
        for (i in 0 until view.childCount) {
            val innerView = view.getChildAt(i)
            hideKeyboardHandler(innerView, context)
        }
    }
}

fun hideSoftKeyboard(view: View, context: Context) {
    val inputMethodManager = context!!.getSystemService(
        Activity.INPUT_METHOD_SERVICE
    ) as InputMethodManager
    inputMethodManager.hideSoftInputFromWindow(
        view?.rootView?.windowToken, 0
    )
}