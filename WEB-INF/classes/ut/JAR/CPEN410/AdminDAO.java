package ut.JAR.CPEN410;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * AdminDAO
 * --------
 * Utility class that performs administrative operations on user‑related
 * tables.  **All SQL is built via string concatenation** and executed through
 * the helper methods of {@link MySQLCompleteConnector}.
 *
 * <p>Main features:</p>
 * <ul>
 *   <li>List every user</li>
 *   <li>Create users and assign <em>ADMIN</em> or <em>USER</em> role</li>
 *   <li>Update user profile data and picture</li>
 *   <li>Verify if a user owns role <em>ADMIN</em></li>
 *   <li>Delete users and individual photos</li>
 *   <li>Fetch photos and user rows by id</li>
 * </ul>
 */
public class AdminDAO {

    /** Low‑level connector wrapper */
    private final MySQLCompleteConnector connector;

    /** Opens the DB connection upon instantiation. */
    public AdminDAO() {
        System.out.println("AdminDAO loaded.");
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }

    /* ───────────────────────── helpers ───────────────────────── */

    /** True if the e‑mail already exists in <code>users</code>. */
    private boolean emailExists(String email) throws SQLException {
        ResultSet rs = connector.doSelect("id", "users", "email='" + email + "'");
        boolean found = rs.next();
        rs.close();
        return found;
    }

    /** Returns the id of a role; creates it if missing. */
    private int getOrCreateRole(String roleName) {
        try {
            ResultSet rs = connector.doSelect("id", "roles", "name='" + roleName + "'");
            if (rs.next()) { int id = rs.getInt("id"); rs.close(); return id; }
            rs.close();
            if (!connector.doInsert("roles(name)", "'" + roleName + "'")) { // false → success
                ResultSet rs2 = connector.doSelect("id", "roles", "name='" + roleName + "'");
                if (rs2.next()) { int id = rs2.getInt("id"); rs2.close(); return id; }
                rs2.close();
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    /* ───────────────────────── public API ───────────────────── */

    /** List all users with public profile fields. */
    public ResultSet listUsers() throws SQLException {
        return connector.doSelect(
            "id, name, email, birth_date, gender, profile_picture",
            "users",
            "1=1");
    }

    /**
     * Inserts a new user row and assigns a role.
     *
     * @param name      full name
     * @param email     unique e‑mail
     * @param password  plain‑text password
     * @param birthDate YYYY‑MM‑DD
     * @param gender    Male / Female / Other
     * @param address   (ignored in current schema)
     * @param education (ignored in current schema)
     * @param isAdmin   if true assigns role ADMIN, else USER
     * @return true when every insert succeeds
     */
    public boolean addUser(String name,
                           String email,
                           String password,
                           String birthDate,
                           String gender,
                           String address,
                           String education,
                           boolean isAdmin) {

        try {
            if (emailExists(email)) {
                System.out.println("E‑mail already registered: " + email);
                return false;
            }

            /* insert into users */
            String userVals = "'" + name + "', '" + email + "', SHA2('"
                            + password + "',256), '" + birthDate + "', '"
                            + gender + "', NULL, NULL";

            boolean userErr = connector.doInsert(
                "users(name,email,password,birth_date,gender,profile_picture,last_page_id)",
                userVals);

            if (userErr) return false;          // true → insertion failed

            /* get id of the row just inserted */
            ResultSet rs = connector.doSelect(
                "id", "users",
                "email='" + email + "' ORDER BY id DESC LIMIT 1");
            if (!rs.next()) { rs.close(); return false; }
            long userId = rs.getLong("id");
            rs.close();

            /* insert role */
            int roleId = getOrCreateRole(isAdmin ? "ADMIN" : "USER");
            if (roleId == -1) return false;

            boolean roleErr = connector.doInsert(
                "user_roles(user_id,role_id)",
                userId + ", " + roleId);

            return !roleErr;                    // false means OK
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Update name, e‑mail, birth date and gender. */
    public boolean updateUser(long id,
                              String name,
                              String email,
                              String birthDate,
                              String gender) {
        String sql = "UPDATE users SET name='" + name
                   + "', email='" + email
                   + "', birth_date='" + birthDate
                   + "', gender='" + gender
                   + "' WHERE id=" + id;
        try {
            return connector.getConnection()
                            .createStatement()
                            .executeUpdate(sql) > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /** True if the user owns role ADMIN. */
    public boolean isAdmin(long userId) {
        try {
            ResultSet rs = connector.doSelect(
                "r.name",
                "roles r, user_roles ur",
                "r.id = ur.role_id AND ur.user_id = " + userId);
            while (rs.next()) {
                if ("ADMIN".equalsIgnoreCase(rs.getString("name"))) {
                    rs.close(); return true;
                }
            }
            rs.close();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Delete a user row. */
    public boolean deleteUser(long id) {
        String sql = "DELETE FROM users WHERE id=" + id;
        try {
            return connector.getConnection()
                            .createStatement()
                            .executeUpdate(sql) > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /* ───────────── photos ───────────── */

    /** Every photo post of a user ordered by newest first. */
    public ResultSet getUserPhotos(long userId) throws SQLException {
        return connector.doSelect(
            "id, image_url, upload_date",
            "images",
            "user_id=" + userId + " ORDER BY upload_date DESC");
    }

    /** Delete a photo post. */
    public boolean deletePhoto(long photoId) {
        String sql = "DELETE FROM images WHERE id=" + photoId;
        try {
            return connector.getConnection()
                            .createStatement()
                            .executeUpdate(sql) > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /** Update <code>profile_picture</code> for the selected user. */
    public boolean updateUserProfilePicture(long id, String pic) {
        String sql = "UPDATE users SET profile_picture='" + pic
                   + "' WHERE id=" + id;
        try {
            return connector.getConnection()
                            .createStatement()
                            .executeUpdate(sql) > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /** Retrieve the user row matching the given primary key. */
    public ResultSet getUserById(long id) throws SQLException {
        return connector.doSelect(
            "id, name, email, birth_date, gender, profile_picture",
            "users",
            "id=" + id);
    }

    /** Close the underlying connection. */
    public void close() {
        connector.closeConnection();
    }
}
