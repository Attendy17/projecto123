package com.example.minifacebook;

import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.bumptech.glide.Glide;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * ProfileFragment
 *
 * Displays the current user's profile feed including posts with images.
 * Posts are fetched from the ProfileServlet using the current user's ID.
 */
public class ProfileFragment extends Fragment {

    private jsonPerson currentUser;
    private LinearLayout postContainer;

    private static final String BASE_URL = "http://192.168.1.16:8089";

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.fragment_profile, container, false);
        postContainer = view.findViewById(R.id.friendListContainer);

        // Retrieve user object from arguments
        if (getArguments() != null) {
            currentUser = (jsonPerson) getArguments().getSerializable("currentUser");
            if (currentUser != null) {
                new FetchPostTask().execute(currentUser.getId());
            } else {
                TextView t = new TextView(requireContext());
                t.setText("User data not received.");
                postContainer.addView(t);
            }
        }

        return view;
    }

    /**
     * AsyncTask to retrieve posts from the server for the current user.
     */
    private class FetchPostTask extends AsyncTask<String, Void, String> {
        @Override
        protected String doInBackground(String... params) {
            String userId = params[0];
            String url = BASE_URL + "/ProfileServlet";
            String postData = "userId=" + userId;
            return new HttpHandler().makeServiceCallPost(url, postData);
        }

        @Override
        protected void onPostExecute(String result) {
            try {
                JSONObject json = new JSONObject(result);
                JSONArray posts = json.getJSONArray("posts");

                if (posts.length() == 0) {
                    TextView t = new TextView(requireContext());
                    t.setText("No posts found.");
                    postContainer.addView(t);
                    return;
                }

                for (int i = 0; i < posts.length(); i++) {
                    JSONObject post = posts.getJSONObject(i);
                    String name = post.optString("name", "Unnamed");
                    String date = post.optString("upload_date", "No date");
                    String imageUrl = post.optString("image_url", "");

                    // Create post metadata view
                    TextView text = new TextView(requireContext());
                    text.setText("Posted by: " + name + "\nDate: " + date);
                    text.setPadding(0, 24, 0, 8);
                    postContainer.addView(text);

                    // Create image view if image URL is present
                    if (!imageUrl.isEmpty()) {
                        ImageView image = new ImageView(requireContext());
                        image.setLayoutParams(new LinearLayout.LayoutParams(
                                ViewGroup.LayoutParams.MATCH_PARENT, 500));
                        image.setScaleType(ImageView.ScaleType.CENTER_CROP);
                        Glide.with(requireContext()).load(imageUrl).into(image);
                        postContainer.addView(image);
                    }
                }

            } catch (Exception e) {
                TextView t = new TextView(requireContext());
                t.setText("Error processing JSON.");
                postContainer.addView(t);
                Log.e("ProfileFragment", "JSON Parsing Error", e);
            }
        }
    }
}
