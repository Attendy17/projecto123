package ut.JAR.CPEN410;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * applicationDBAuthenticationGoodComplete
 * ---------------------------------------
 * Handles <strong>login</strong>, retrieves the current user role and performs
 * the <em>sign‑up</em> operation.  Every SQL statement is built through
 * simple String concatenation and executed via the helper methods exposed by
 * {@link MySQLCompleteConnector}; there are no PreparedStatement placeholders
 * (keeps the same pattern required by the professor).
 */
public class applicationDBAuthenticationGoodComplete {

    /** Low‑level connector wrapper. */
    private final MySQLCompleteConnector myDBConn;

    public applicationDBAuthenticationGoodComplete() {
        System.out.println("applicationDBAuthenticationGoodComplete loaded.");
        myDBConn = new MySQLCompleteConnector();
        myDBConn.doConnection();
    }

    /* ───────────────────────── authentication */

    /**
     * Returns a ResultSet with <code>id,email,name</code> when the credentials
     * match.
     */
    public ResultSet authenticate(String email, String userPass) {
        String fields = "id, email, name";
        String tables = "users";
        String where  = "email='" + email + "' AND password=SHA2('" + userPass + "',256)";
        System.out.println("authenticate ? " + where);
        return myDBConn.doSelect(fields, tables, where);
    }

    /* ───────────────────────── role */

    /** Returns <code>ADMIN</code> or <code>USER</code> (empty string if none). */
    public String getUserRole(long userId) {
        try {
            ResultSet rs = myDBConn.doSelect(
                "r.name",                          // fields
                "roles r, user_roles ur",          // tables
                "r.id = ur.role_id AND ur.user_id=" + userId); // where
            if (rs.next()) {
                String role = rs.getString(1);
                rs.close();
                return role;
            }
            rs.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return "";
    }

    /* ───────────────────────── sign‑up */

    /**
     * Inserts a new row into <code>users</code>; profile_picture and
     * last_page_id are stored as NULL.
     *
     * @return <code>true</code> when the INSERT succeeds.
     */
    public boolean addUser(String email,
                           String completeName,
                           String userPass,
                           String birthDate,
                           String gender) {
        // escape single quotes that would break syntax
        completeName = completeName.replace("'", "''");

        String cols  = "users(name,email,password,birth_date,gender,profile_picture,last_page_id)";
        String vals  = "'" + completeName + "', '" + email + "', SHA2('" + userPass + "',256), '"
                     + birthDate + "', '" + gender + "', NULL, NULL";

        boolean err = myDBConn.doInsert(cols, vals);
        System.out.println("Insertion executed: " + err);
        return !err;   // false → executed OK
    }

    /* ───────────────────────── misc */

    /** Returns auxiliary user data (example: last_page_id) by e‑mail. */
    public ResultSet getUserData(String email) {
        return myDBConn.doSelect("last_page_id", "users", "email='" + email + "'");
    }

    /** Close JDBC connection. */
    public void close() { myDBConn.closeConnection(); }
}
