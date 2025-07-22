package ut.JAR.CPEN410;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * ProfileDAO
 * ----------
 * Centralises every operation related to a **user profile**:
 *
 * <ul>
 *   <li>Read public profile data (<em>name, email, picture, birth&nbsp;date</em>).</li>
 *   <li>Update the profile picture.</li>
 *   <li>Upsert (update&nbsp;/&nbsp;insert) the user’s <strong>education</strong> row.</li>
 *   <li>Upsert the user’s <strong>address</strong> row.</li>
 *   <li>Publish, list and delete <strong>photo posts</strong>.</li>
 * </ul>
 *
 * <p><b>Coding pattern</b>: all SQL statements are built by concatenation
 * (no <code>?</code>) as required by the course template.  Single quotes in text
 * parameters are escaped (<code>' → ''</code>).</p>
 *
 * <p>The four update/insert methods keep a <code>void</code> signature so that
 * existing JSP pages compiled against the old version continue to run without
 * recompilation.</p>
 */
public class ProfileDAO {

    /** Helper that keeps an open JDBC connection. */
    private final MySQLCompleteConnector connector;

    /** Opens the database connection on construction. */
    public ProfileDAO() {
        System.out.println("ProfileDAO loaded.");
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }

    /* ───────────────────────── basic profile ─────────────────────── */

    /** Returns <kbd>name, email, profile_picture, birth_date</kbd> for <code>userId</code>. */
    public ResultSet getUserProfile(long userId) throws SQLException {
        return connector.doSelect(
                "name, email, profile_picture, birth_date",
                "users",
                "id=" + userId);
    }

    /* ───────────────────────── profile picture ──────────────────── */

    /**
     * Replaces the profile picture.  Signature kept as <code>void</code> for
     * binary compatibility with older JSPs.
     */
    public void updateProfilePicture(long userId, String pic) {
        pic = pic.replace("'", "''");
        String sql = "UPDATE users SET profile_picture='" + pic + "' WHERE id=" + userId;
        try { connector.getConnection().createStatement().executeUpdate(sql); }
        catch (SQLException e) { e.printStackTrace(); }
    }

    /* ───────────────────────── education ────────────────────────── */

    /**
     * Inserts or updates the row in <code>education</code> tied to the user.
     * Returns <code>void</code>; JSPs simply invoke the method and ignore any
     * flag.
     */
    public void updateEducation(long userId, String degree, String school) {
        degree = degree.replace("'", "''");
        school = school.replace("'", "''");

        try {
            boolean exists = connector.doSelect("COUNT(*) AS c",
                                                "education",
                                                "user_id=" + userId)
                                      .next();
            String sql = exists
                ? "UPDATE education SET degree='" + degree + "', school='" + school +
                  "' WHERE user_id=" + userId
                : "INSERT INTO education(user_id,degree,school) VALUES(" + userId +
                  ", '" + degree + "', '" + school + "')";
            connector.getConnection().createStatement().executeUpdate(sql);
        } catch (SQLException e) { e.printStackTrace(); }
    }

    /* ───────────────────────── address ─────────────────────────── */

    /** Upserts the row in <code>addresses</code> associated with the user. */
    public void updateAddress(long userId,
                              String street,
                              String town,
                              String state,
                              String country) {
        street  = street.replace("'", "''");
        town    = town.replace("'", "''");
        state   = state.replace("'", "''");
        country = country.replace("'", "''");

        try {
            boolean exists = connector.doSelect("COUNT(*) AS c",
                                                "addresses",
                                                "user_id=" + userId)
                                      .next();
            String sql = exists
                ? "UPDATE addresses SET street='" + street + "', town='" + town +
                  "', state='" + state + "', country='" + country +
                  "' WHERE user_id=" + userId
                : "INSERT INTO addresses(user_id,street,town,state,country) VALUES(" +
                  userId + ", '" + street + "', '" + town + "', '" + state + "', '" +
                  country + "')";
            connector.getConnection().createStatement().executeUpdate(sql);
        } catch (SQLException e) { e.printStackTrace(); }
    }

    /* ───────────────────────── photos – user ───────────────────── */

    /** Publishes a new photo post (kept as <code>void</code> for compatibility). */
    public void addPhoto(long userId, String url) {
        url = url.replace("'", "''");
        connector.doInsert("images(user_id,image_url)", userId + ", '" + url + "'");
    }

    /** Returns every photo post of the user ordered by newest first. */
    public ResultSet getUserPhotos(long userId) throws SQLException {
        return connector.doSelect(
                "id, image_url, upload_date",
                "images",
                "user_id=" + userId + " ORDER BY upload_date DESC");
    }

    /* ───────────────────────── photos – friends feed ───────────── */

    /** Retrieves photo posts published by friends with status <em>accepted</em>. */
    public ResultSet getFriendPhotos(long userId) throws SQLException {
        String sql = "SELECT i.id,i.image_url,i.upload_date,u.name " +
                     "FROM images i JOIN users u ON i.user_id=u.id " +
                     "WHERE i.user_id IN (" +
                     "  SELECT CASE WHEN user1_id=" + userId +
                     "         THEN user2_id ELSE user1_id END " +
                     "  FROM friendships " +
                     "  WHERE (user1_id=" + userId + " OR user2_id=" + userId + ")" +
                     "    AND status='accepted')" +
                     "ORDER BY i.upload_date DESC";
        return connector.getConnection().createStatement().executeQuery(sql);
    }

    /* ───────────────────────── photos – delete ─────────────────── */

    /** Deletes the photo post with primary‑key <code>photoId</code>. */
    public void deletePhoto(long photoId) {
        try {
            connector.getConnection()
                     .createStatement()
                     .executeUpdate("DELETE FROM images WHERE id=" + photoId);
        } catch (SQLException e) { e.printStackTrace(); }
    }

    /** Devuelve todas las fotos sin filtrar por amistades (solo para pruebas). */
    public ResultSet getAllPhotos() throws SQLException {
      String sql = "SELECT i.id, i.image_url, i.upload_date, u.name " +
                   "FROM images i JOIN users u ON i.user_id = u.id " +
                   "ORDER BY i.upload_date DESC LIMIT 1";
         return connector.getConnection().createStatement().executeQuery(sql);
    }


    /* ───────────────────────── shutdown ────────────────────────── */

    /** Closes the open JDBC connection. */
    public void close() { connector.closeConnection(); }
}
