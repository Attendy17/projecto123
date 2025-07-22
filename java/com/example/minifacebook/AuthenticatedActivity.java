package com.example.minifacebook;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;

import com.google.android.material.bottomnavigation.BottomNavigationView;

/**
 * AuthenticatedActivity
 *
 * This is the main activity shown after a user successfully logs in.
 * It displays a BottomNavigationView with the following sections:
 *   • ProfileFragment      - displays the user's timeline and profile info
 *   • SearchFragment       - allows the user to search for other users
 *   • FriendListFragment   - shows friend requests and current friends list
 *
 * A serialized jsonPerson object (current user data) is received via Intent.
 */
public class AuthenticatedActivity extends AppCompatActivity {

    private jsonPerson currentUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_authenticated);

        // Retrieve user data passed from login activity
        Intent intent = getIntent();
        currentUser = (jsonPerson) intent.getSerializableExtra("jPerson");

        // Set up sign-out button
        Button signOut = findViewById(R.id.buttonSignOut);
        signOut.setOnClickListener(v -> {
            // Return to login screen and clear activity history
            Intent i = new Intent(this, MainActivity.class);
            i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            startActivity(i);
            finish();
        });

        // Initialize bottom navigation bar
        BottomNavigationView nav = findViewById(R.id.bottomNav);

        nav.setOnItemSelectedListener(item -> {
            int id = item.getItemId();

            // Navigate to SearchFragment
            if (id == R.id.nav_search) {
                SearchFragment sf = new SearchFragment();
                Bundle b = new Bundle();
                b.putSerializable("currentUser", currentUser);
                sf.setArguments(b);
                loadFragment(sf);
                return true;

                // Navigate to FriendListFragment
            } else if (id == R.id.nav_friends) {
                FriendListFragment ff = new FriendListFragment();
                Bundle b = new Bundle();
                b.putSerializable("currentUser", currentUser);
                ff.setArguments(b);
                loadFragment(ff);
                return true;

                // Navigate to ProfileFragment
            } else if (id == R.id.nav_profile) {
                ProfileFragment pf = new ProfileFragment();
                Bundle b = new Bundle();
                b.putSerializable("currentUser", currentUser);
                pf.setArguments(b);
                loadFragment(pf);
                return true;
            }

            return false;
        });

        // Set the default fragment when the activity starts
        nav.setSelectedItemId(R.id.nav_profile);
    }

    /**
     * Loads the selected fragment into the content frame
     * @param fragment Fragment to display
     */
    private void loadFragment(@NonNull Fragment fragment) {
        getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.contentFrame, fragment)
                .commit();
    }
}
