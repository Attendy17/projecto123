package ut.JAR.CPEN410;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * FriendshipDAO
 * --------------
 * Manages friend‑request flows.  All SQL sentences are built via simple
 * String concatenation and executed through {@link MySQLCompleteConnector};
 * no PreparedStatement is used.
 */
public class FriendshipDAO {

    private final MySQLCompleteConnector connector;

    public FriendshipDAO() {
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }

    /* ───────────────────────── send request */

    /**
     * Creates a <code>pending</code> row unless one already exists in either
     * direction.
     */
    public boolean sendFriendRequest(long user1Id, long user2Id) throws SQLException {
        // look for any existing relation (pending or accepted)
        String where = "(user1_id=" + user1Id + " AND user2_id=" + user2Id + ") OR " +
                       "(user1_id=" + user2Id + " AND user2_id=" + user1Id + ")";
        ResultSet rs  = connector.doSelect("COUNT(*) AS c", "friendships", where);
        rs.next();
        int count = rs.getInt("c");
        rs.close();
        if (count > 0) return false; // already reqsuested / friends

        // insert new request
        String vals = user1Id + ", " + user2Id + ", 'pending'";
        boolean err = connector.doInsert("friendships(user1_id,user2_id,status)", vals);
        return !err; // false → success
    }

    /* ───────────────────────── accept request */

    public boolean acceptFriendRequest(long friendshipId) {
        String sql = "UPDATE friendships SET status='accepted' " +
                     "WHERE id=" + friendshipId + " AND status='pending'";
        try {
            Statement st = connector.getConnection().createStatement();
            return st.executeUpdate(sql) > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    /* ───────────────────────── query helpers */

    /** Pending requests where <code>userId</code> is recipient. */
    public ResultSet listIncomingRequests(long userId) throws SQLException {
        String fields = "f.id, f.user1_id, f.status, f.created_at, u.name AS senderName";
        String tables = "friendships f, users u";
        String where  = "f.user1_id = u.id AND f.user2_id=" + userId + " AND f.status='pending'";
        return connector.doSelect(fields, tables, where);
    }

    /** Rows with status <code>accepted</code> where the user participates. */
    public ResultSet listFriends(long userId) throws SQLException {
        String fields = "id, user1_id, user2_id, created_at";
        String tables = "friendships";
        String where  = "status='accepted' AND (user1_id=" + userId + " OR user2_id=" + userId + ")";
        return connector.doSelect(fields, tables, where);
    }

    public void close() { connector.closeConnection(); }
}
