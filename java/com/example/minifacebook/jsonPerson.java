package com.example.minifacebook;

import org.json.JSONObject;
import java.io.Serializable;

/**
 * jsonPerson
 *
 * This class defines a user object with the following attributes:
 *   - id: Unique identifier of the user
 *   - name: Full name of the user
 *   - userName: Username used for login/display
 *   - email: Email address of the user
 *
 * The class implements Serializable to allow object transfer between activities via Intents.
 */
public class jsonPerson implements Serializable {

    private String name;
    private String email;
    private String userName;
    private String id;

    /**
     * Constructor using individual field values.
     *
     * @param id        User ID
     * @param name      User's full name
     * @param email     User's email address
     * @param userName  User's username
     */
    public jsonPerson(String id, String name, String email, String userName) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.userName = userName;
    }

    /**
     * Constructor using a JSON string formatted as:
     * {
     *     "id": "value0",
     *     "userName": "value1",
     *     "name": "value2",
     *     "email": "value3"
     * }
     *
     * @param jsonFile  JSON-formatted string containing user attributes
     */
    public jsonPerson(String jsonFile) {
        try {
            JSONObject jsonObj = new JSONObject(jsonFile);
            this.id = jsonObj.getString("id");
            this.name = jsonObj.getString("name");
            this.userName = jsonObj.getString("userName");
            this.email = jsonObj.getString("email");
        } catch (Exception e) {
            e.printStackTrace(); // Log parsing error
        }
    }

    // ----------------- Accessor Methods -----------------

    /** @return User's full name */
    public String getName() {
        return name;
    }

    /** @return User's email address */
    public String getEmail() {
        return email;
    }

    /** @return User's username */
    public String getUserName() {
        return userName;
    }

    /** @return User's unique ID */
    public String getId() {
        return id;
    }
}
