package ut.JAR.CPEN410;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * FriendshipDAO
 * --------------
 * Maneja solicitudes de amistad utilizando concatenación directa de Strings.
 * No utiliza PreparedStatement.
 */
public class FriendshipDAO {

    private final MySQLCompleteConnector connector;

    public FriendshipDAO() {
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }

    /** Envía una solicitud de amistad, siempre y cuando no exista ya una relación en cualquier dirección. */
    public boolean sendFriendRequest(long user1Id, long user2Id) throws SQLException {
        String condition = "(user1_id=" + user1Id + " AND user2_id=" + user2Id + ") OR " +
                           "(user1_id=" + user2Id + " AND user2_id=" + user1Id + ")";
        ResultSet rs = connector.doSelect("COUNT(*) AS cantidad", "friendships", condition);
        rs.next();
        int count = rs.getInt("cantidad");
        rs.close();

        if (count > 0) {
            return false;
        }

        String values = user1Id + ", " + user2Id + ", 'pending'";
        boolean inserted = connector.doInsert("friendships(user1_id,user2_id,status)", values);
        return !inserted;
    }

    /** Acepta una solicitud de amistad existente con estatus 'pending'. */
    public boolean acceptFriendRequest(long friendshipId) {
        String update = "UPDATE friendships SET status='accepted' " +
                        "WHERE id=" + friendshipId + " AND status='pending'";
        try {
            Statement st = connector.getConnection().createStatement();
            int rows = st.executeUpdate(update);
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Devuelve las solicitudes entrantes para el usuario dado. */
    public ResultSet listIncomingRequests(long userId) throws SQLException {
        String fields = "f.id, f.user1_id, f.status, f.created_at, u.name";
        String tables = "friendships f, users u";
        String condition = "f.user1_id = u.id AND f.user2_id=" + userId + " AND f.status='pending'";
        return connector.doSelect(fields, tables, condition);
    }

    /** Lista las amistades confirmadas del usuario. */
    public ResultSet listFriends(long userId) throws SQLException {
        String fields = "id, user1_id, user2_id, created_at";
        String tables = "friendships";
        String condition = "status='accepted' AND (user1_id=" + userId + " OR user2_id=" + userId + ")";
        return connector.doSelect(fields, tables, condition);
    }

    /** Cierra la conexión al terminar. */
    public void close() {
        connector.closeConnection();
    }
}
