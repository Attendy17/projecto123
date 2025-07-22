package com.example.minifacebook;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

/**
 * HttpHandler
 *
 * Utility class for handling HTTP network requests.
 * Supports both GET and POST methods, including:
 *   - Login via POST with username and password
 *   - Generic POST request with URL-encoded parameters
 *   - Generic GET request
 */
public class HttpHandler {

    /**
     * Performs a POST request with login credentials.
     *
     * @param reqUrl    URL to send the request to
     * @param userName  Username to include in the POST body
     * @param pass      Password to include in the POST body
     * @return          Server response as a string
     */
    public String makeServiceCallPost(String reqUrl, String userName, String pass) {
        String params = "user=" + userName + "&pass=" + pass;
        return makeServiceCallPost(reqUrl, params);
    }

    /**
     * Performs a generic POST request with URL-encoded parameters.
     *
     * @param reqUrl            URL to send the request to
     * @param urlEncodedParams  Parameters formatted as URL-encoded string (e.g., key1=value1&key2=value2)
     * @return                  Server response as a string
     */
    public String makeServiceCallPost(String reqUrl, String urlEncodedParams) {
        String response = null;
        HttpURLConnection conn = null;

        try {
            URL url = new URL(reqUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setConnectTimeout(5000);  // Optional timeout setting
            conn.setReadTimeout(5000);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            // Send POST data
            OutputStream os = conn.getOutputStream();
            os.write(urlEncodedParams.getBytes("UTF-8"));
            os.flush();
            os.close();

            // Handle response
            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                InputStream in = new BufferedInputStream(conn.getInputStream());
                response = convertStreamToString(in);
            } else {
                System.out.println("HTTP error code: " + responseCode);
            }

        } catch (MalformedURLException | ProtocolException e) {
            System.out.println(e.getClass().getSimpleName() + ": " + e.getMessage());
        } catch (IOException e) {
            System.out.println("IOException: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        } finally {
            if (conn != null) conn.disconnect();
        }

        return response;
    }

    /**
     * Performs a generic GET request.
     *
     * @param reqUrl  URL to send the GET request to
     * @return        Server response as a string
     */
    public String makeServiceCall(String reqUrl) {
        String response = null;
        HttpURLConnection conn = null;

        try {
            URL url = new URL(reqUrl);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            // Handle response
            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                InputStream in = new BufferedInputStream(conn.getInputStream());
                response = convertStreamToString(in);
            } else {
                System.out.println("HTTP error code: " + responseCode);
            }

        } catch (MalformedURLException | ProtocolException e) {
            System.out.println(e.getClass().getSimpleName() + ": " + e.getMessage());
        } catch (IOException e) {
            System.out.println("IOException: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());
        } finally {
            if (conn != null) conn.disconnect();
        }

        return response;
    }

    /**
     * Helper method to convert an InputStream into a String.
     *
     * @param is  Input stream from the server response
     * @return    Full response as a string
     * @throws IOException if reading the stream fails
     */
    private static String convertStreamToString(InputStream is) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = reader.readLine()) != null) {
            sb.append(line).append('\n');
        }

        is.close();
        return sb.toString().trim();  // Trim to remove trailing newline
    }
}
