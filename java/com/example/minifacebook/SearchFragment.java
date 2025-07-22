package com.example.minifacebook;

import android.os.AsyncTask;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.bumptech.glide.Glide;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * SearchFragment
 *
 * Allows users to search for other users by name or keyword.
 * Displays matching results with the option to send a friend request.
 */
public class SearchFragment extends Fragment {

    private EditText inputSearch;
    private LinearLayout resultsContainer;
    private jsonPerson currentUser;

    // Update this if your Tomcat IP address or port changes
    private static final String BASE_URL = "http://192.168.1.16:8089";

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.fragment_search, container, false);

        inputSearch = view.findViewById(R.id.editSearch);
        resultsContainer = view.findViewById(R.id.resultsContainer);

        // Retrieve current user from arguments
        if (getArguments() != null) {
            currentUser = (jsonPerson) getArguments().getSerializable("currentUser");
        }

        // Handle search button click
        view.findViewById(R.id.buttonSearch).setOnClickListener(v -> {
            String query = inputSearch.getText().toString().trim();
            if (!TextUtils.isEmpty(query)) {
                new SearchTask().execute(query);
            }
        });

        return view;
    }

    /**
     * AsyncTask to fetch search results based on query string.
     */
    private class SearchTask extends AsyncTask<String, Void, String> {
        @Override
        protected String doInBackground(String... params) {
            String query = params[0];
            String url = BASE_URL + "/SearchFriendServlet?q=" + query;
            return new HttpHandler().makeServiceCall(url);
        }

        @Override
        protected void onPostExecute(String result) {
            resultsContainer.removeAllViews();

            try {
                JSONObject json = new JSONObject(result);
                JSONArray array = json.getJSONArray("results");

                for (int i = 0; i < array.length(); i++) {
                    JSONObject obj = array.getJSONObject(i);
                    View userView = LayoutInflater.from(getContext())
                            .inflate(R.layout.item_search_result, resultsContainer, false);

                    TextView nameView = userView.findViewById(R.id.friendName);
                    TextView ageView = userView.findViewById(R.id.friendAge);
                    TextView townView = userView.findViewById(R.id.friendTown);
                    ImageView photoView = userView.findViewById(R.id.friendImage);
                    Button addButton = userView.findViewById(R.id.buttonAddFriend);

                    long targetUserId = obj.getLong("id");

                    nameView.setText(obj.getString("name"));
                    ageView.setText("Age: " + obj.getInt("age"));
                    townView.setText("Town: " + obj.getString("town"));

                    String picUrl = obj.optString("profile_picture", "");
                    if (!picUrl.isEmpty()) {
                        Glide.with(getContext()).load(picUrl).into(photoView);
                    }

                    addButton.setOnClickListener(v -> {
                        if (currentUser != null) {
                            new SendFriendRequestTask().execute(
                                    currentUser.getId(),
                                    String.valueOf(targetUserId)
                            );
                        } else {
                            Toast.makeText(getContext(), "User not loaded", Toast.LENGTH_SHORT).show();
                        }
                    });

                    resultsContainer.addView(userView);
                }

            } catch (Exception e) {
                e.printStackTrace();
                TextView errorText = new TextView(getContext());
                errorText.setText("Error processing search results.");
                resultsContainer.addView(errorText);
            }
        }
    }

    /**
     * AsyncTask to send a friend request from the current user to the selected user.
     */
    private class SendFriendRequestTask extends AsyncTask<String, Void, String> {
        @Override
        protected String doInBackground(String... ids) {
            String senderId = ids[0];
            String receiverId = ids[1];
            String data = "user1=" + senderId + "&user2=" + receiverId;
            return new HttpHandler().makeServiceCallPost(BASE_URL + "/FriendServlet", data);
        }

        @Override
        protected void onPostExecute(String result) {
            Toast.makeText(getContext(), "Friend request sent", Toast.LENGTH_SHORT).show();
            Log.d("FriendRequest", "Result: " + result);
        }
    }
}
