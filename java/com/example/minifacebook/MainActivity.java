package com.example.minifacebook;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

/**
 * MainActivity
 *
 * Login screen for Mini-Facebook.
 * Sends the username and password to the /sessionServlet.
 * If the response is "not", credentials are incorrect.
 * Otherwise, it launches the authenticated session.
 */
public class MainActivity extends AppCompatActivity {

    // ----------------------------- CONFIGURATION -----------------------------
    // Modify only the IP:port to match your Tomcat server
    private static final String HOST_PORT = "192.168.1.16:8089";
    private static final String SERVLET = "sessionServlet"; // No leading slash
    // -------------------------------------------------------------------------

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button btnLogin = findViewById(R.id.buttonSubmit);
        btnLogin.setOnClickListener(v -> new LoginTask(this).execute());
    }

    /**
     * LoginTask
     *
     * AsyncTask that handles user authentication in the background.
     * On success, transitions to AuthenticatedActivity with the user data.
     */
    private static class LoginTask extends AsyncTask<Void, Void, String> {

        private final Activity ctx;
        private String user, pass;

        LoginTask(Activity context) {
            this.ctx = context;
        }

        @Override
        protected void onPreExecute() {
            Toast.makeText(ctx, "Authenticating…", Toast.LENGTH_SHORT).show();
            user = ((EditText) ctx.findViewById(R.id.editUsername)).getText().toString();
            pass = ((EditText) ctx.findViewById(R.id.editPwd)).getText().toString();
        }

        @Override
        protected String doInBackground(Void... voids) {
            String url = "http://" + HOST_PORT + "/" + SERVLET;
            return new HttpHandler().makeServiceCallPost(url, user, pass);
        }

        @Override
        protected void onPostExecute(String response) {
            if (response == null) {
                showToast("Connection error");
                return;
            }

            if ("\"not\"".equals(response.trim())) {
                showToast("Incorrect username or password");
                return;
            }

            try {
                // Parse JSON response into a user object
                jsonPerson jPerson = new jsonPerson(response);

                Intent intent = new Intent(ctx, AuthenticatedActivity.class);
                intent.putExtra("jPerson", jPerson);
                ctx.startActivity(intent);

            } catch (Exception e) {
                e.printStackTrace();
                showToast("Error processing server response");
            }
        }

        private void showToast(String message) {
            Toast.makeText(ctx, message, Toast.LENGTH_LONG).show();
        }
    }
}
