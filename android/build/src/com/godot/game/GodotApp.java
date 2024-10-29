/**************************************************************************/
/*  GodotApp.java                                                         */
/**************************************************************************/
/*                         This file is part of:                          */
/*                             GODOT ENGINE                               */
/*                        https://godotengine.org                         */
/**************************************************************************/
/* Copyright (c) 2014-present Godot Engine contributors (see AUTHORS.md). */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/

package com.godot.game;

import org.godotengine.godot.GodotActivity;

import android.app.Activity;

import android.content.Intent;

import android.net.Uri;

import android.os.Bundle;

import androidx.core.splashscreen.SplashScreen;

/**
 * Template activity for Godot Android builds.
 * Feel free to extend and modify this class for your custom logic.
 */
public class GodotApp extends GodotActivity {
	private static final String DEEPLINK_SIGNAL = "handle_deek_link";
	private Uri deepLinkData = null;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		SplashScreen.installSplashScreen(this);
		super.onCreate(savedInstanceState);

		handleIntent(getIntent());
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		handleIntent(intent);
	}

	private void handleIntent(Intent intent) {
		if (intent == null) return;

		String action = intent.getAction();
		Uri data = intent.getData();

		if (Intent.ACTION_VIEW.equals(action) && data != null) {
			deepLinkData = data;
			// if (isGodotInitialized()) {
			// 	emitDeepLinkSignal(data);
			// }
		}
	}

	@Override
	public void onGodotMainLoopStarted() {
		super.onGodotMainLoopStarted();

		if (deepLinkData != null) {
			emitDeepLinkSignal(deepLinkData);
			deepLinkData = null;
		}
	}

	private void emitDeepLinkSignal(Uri data) {
		try {
			// Signal scheme = data.getScheme() != null ? data.getScheme() : "";
			// Signal host = data.getHost() != null ? data.getHost() : "";
			// Signal path = data.getPath() != null ? data.getPath() : "";
			// Signal query = data.getQuery() != null ? data.getQuery() : "";

			// String deepLinkData = String.format(
			// 	"{\"scheme\":\"%s\",\"host\":\"%s\",\"path\":\"%s\",\"query\":\"%s\",\"full_uri\":\"%s\"}",
            //     scheme, host, path, query, data.toString()
			// );

			// runOnUiThread(() -> {
			// 	Godot.getInstance().emitSignal(DEEPLINK_SIGNAL, deepLinkData);
			// });
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
