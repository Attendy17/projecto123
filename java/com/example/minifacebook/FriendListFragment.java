package com.example.minifacebook;

import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.bumptech.glide.Glide;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * FriendListFragment
 *
 * This fragment displays two sections:
 *  - Pending friend requests (with accept button)
 *  - Confirmed friends
 *
 * It receives the currentUser object from the parent activity via arguments
 * and fetches the data from the ListFriendsServlet using an AsyncTask.
 */
public class FriendListFragment extends Fragment {

    private LinearLayout friendListContainer;
    private jsonPerson currentUser;
    private static final String BASE_URL = "http://192.168.1.16:8089";

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater,
                             @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.fragment_friend_list, container, false);
        friendListContainer = view.findViewById(R.id.friendListContainer);

        // Retrieve user data passed from parent activity
        if (getArguments() != null) {
            currentUser = (jsonPerson) getArguments().getSerializable("currentUser");
            if (currentUser != null) {
                new LoadFriendsTask().execute(Long.parseLong(currentUser.getId()));
            } else {
                TextView error = new TextView(getContext());
                error.setText("User data not received.");
                friendListContainer.addView(error);
            }
        }

        return view;
    }

    /**
     * AsyncTask to fetch and display the user's friends and friend requests
     */
    private class LoadFriendsTask extends AsyncTask<Long, Void, String> {
        @Override
        protected String doInBackground(Long... params) {
            long currentUserId = params[0];
            return new HttpHandler().makeServiceCall(BASE_URL + "/ListFriendsServlet?userId=" + currentUserId);
        }

        @Override
        protected void onPostExecute(String result) {
            try {
                JSONObject json = new JSONObject(result);
                JSONArray friendsArray = json.getJSONArray("friends");
                JSONArray requestsArray = json.optJSONArray("requests");

                friendListContainer.removeAllViews();

                // Display pending friend requests
                if (requestsArray != null && requestsArray.length() > 0) {
                    TextView header = new TextView(getContext());
                    header.setText("Pending Friend Requests:");
                    friendListContainer.addView(header);

                    for (int i = 0; i < requestsArray.length(); i++) {
                        JSONObject obj = requestsArray.getJSONObject(i);
                        View requestView = LayoutInflater.from(getContext()).inflate(R.layout.item_friend_request, friendListContainer, false);

                        ((TextView) requestView.findViewById(R.id.friendName)).setText(obj.getString("name"));
                        ((TextView) requestView.findViewById(R.id.friendAge)).setText("Age: " + obj.optInt("age", 0));
                        ((TextView) requestView.findViewById(R.id.friendTown)).setText("Town: " + obj.optString("town", ""));

                        String imageUrl = obj.optString("profile_picture", "");
                        if (!imageUrl.isEmpty()) {
                            Glide.with(getContext()).load(imageUrl).into((ImageView) requestView.findViewById(R.id.friendImage));
                        }

                        Button acceptButton = requestView.findViewById(R.id.acceptButton);
                        long friendshipId = obj.getLong("friendship_id");

                        acceptButton.setOnClickListener(v -> new AcceptFriendRequestTask().execute(friendshipId));

                        friendListContainer.addView(requestView);
                    }
                }

                // Display confirmed friends
                TextView header = new TextView(getContext());
                header.setText("Friends:");
                friendListContainer.addView(header);

                for (int i = 0; i < friendsArray.length(); i++) {
                    JSONObject obj = friendsArray.getJSONObject(i);
                    View friendView = LayoutInflater.from(getContext()).inflate(R.layout.item_friend_result, friendListContainer, false);

                    ((TextView) friendView.findViewById(R.id.friendName)).setText(obj.getString("name"));
                    ((TextView) friendView.findViewById(R.id.friendAge)).setText("Age: " + obj.getInt("age"));


                    String imageUrl = obj.optString("profile_picture", "");
                    if (!imageUrl.isEmpty()) {
                        Glide.with(getContext()).load(imageUrl).into((ImageView) friendView.findViewById(R.id.friendImage));
                    }

                    friendListContainer.addView(friendView);
                }

            } catch (Exception e) {
                e.printStackTrace();
                TextView error = new TextView(getContext());
                error.setText("Error loading friends.");
                friendListContainer.addView(error);
            }
        }
    }

    /**
     * AsyncTask to accept a friend request using the friendship ID
     */
    private class AcceptFriendRequestTask extends AsyncTask<Long, Void, String> {
        @Override
        protected String doInBackground(Long... ids) {
            long friendshipId = ids[0];
            return new HttpHandler().makeServiceCall(BASE_URL + "/ListFriendsServlet?action=accept&friendshipId=" + friendshipId);
        }

        @Override
        protected void onPostExecute(String result) {
            Toast.makeText(getContext(), "Friend request accepted", Toast.LENGTH_SHORT).show();
            new LoadFriendsTask().execute(Long.parseLong(currentUser.getId()));
        }
    }
}
