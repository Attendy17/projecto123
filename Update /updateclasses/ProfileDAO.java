package ut.JAR.CPEN410;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * ProfileDAO
 * ----------
 * Centraliza todas las operaciones relacionadas con el perfil de usuario.
 *
 * <ul>
 *   <li>Leer datos públicos del perfil (name, email, picture, birth_date).</li>
 *   <li>Actualizar foto de perfil.</li>
 *   <li>Insertar o actualizar fila de educación y dirección.</li>
 *   <li>Publicar, listar y eliminar fotos.</li>
 * </ul>
 *
 * Patrón: toda consulta se arma por concatenación. No se usa escape manual.
 */
public class ProfileDAO {

    private final MySQLCompleteConnector connector;

    public ProfileDAO() {
        System.out.println("ProfileDAO loaded.");
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }

    public ResultSet getUserProfile(long userId) throws SQLException {
        return connector.doSelect(
            "name, email, profile_picture, birth_date",
            "users",
            "id=" + userId);
    }

    public void updateProfilePicture(long userId, String pic) {
        String sql = "UPDATE users SET profile_picture='" + pic + "' WHERE id=" + userId;
        try {
            connector.getConnection().createStatement().executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateEducation(long userId, String degree, String school) {
        try {
            ResultSet rs = connector.doSelect("COUNT(*) AS c", "education", "user_id=" + userId);
            boolean exists = false;
            if (rs.next()) {
                exists = rs.getInt("c") > 0;
            }
            rs.close();

            String sql;
            if (exists) {
                sql = "UPDATE education SET degree='" + degree + "', school='" + school +
                      "' WHERE user_id=" + userId;
            } else {
                sql = "INSERT INTO education(user_id, degree, school) VALUES(" + userId +
                      ", '" + degree + "', '" + school + "')";
            }
            connector.getConnection().createStatement().executeUpdate(sql);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateAddress(long userId, String street, String town, String state, String country) {
        try {
            ResultSet rs = connector.doSelect("COUNT(*) AS c", "addresses", "user_id=" + userId);
            boolean exists = false;
            if (rs.next()) {
                exists = rs.getInt("c") > 0;
            }
            rs.close();

            String sql;
            if (exists) {
                sql = "UPDATE addresses SET street='" + street + "', town='" + town +
                      "', state='" + state + "', country='" + country +
                      "' WHERE user_id=" + userId;
            } else {
                sql = "INSERT INTO addresses(user_id, street, town, state, country) VALUES(" +
                      userId + ", '" + street + "', '" + town + "', '" + state + "', '" +
                      country + "')";
            }
            connector.getConnection().createStatement().executeUpdate(sql);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addPhoto(long userId, String url) {
        connector.doInsert("images(user_id,image_url)", userId + ", '" + url + "'");
    }

    public ResultSet getUserPhotos(long userId) throws SQLException {
        return connector.doSelect(
            "id, image_url, upload_date",
            "images",
            "user_id=" + userId + " ORDER BY upload_date DESC");
    }

    public ResultSet getFriendPhotos(long userId) throws SQLException {
        String sql = "SELECT i.id, i.image_url, i.upload_date, u.name " +
                     "FROM images i JOIN users u ON i.user_id = u.id " +
                     "WHERE i.user_id IN (" +
                     "  SELECT CASE WHEN user1_id=" + userId +
                     "         THEN user2_id ELSE user1_id END " +
                     "  FROM friendships " +
                     "  WHERE (user1_id=" + userId + " OR user2_id=" + userId + ")" +
                     "    AND status='accepted')" +
                     "ORDER BY i.upload_date DESC";
        return connector.getConnection().createStatement().executeQuery(sql);
    }

    public void deletePhoto(long photoId) {
        try {
            connector.getConnection().createStatement().executeUpdate("DELETE FROM images WHERE id=" + photoId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ResultSet getAllPhotos() throws SQLException {
        String sql = "SELECT i.id, i.image_url, i.upload_date, u.name " +
                     "FROM images i JOIN users u ON i.user_id = u.id " +
                     "ORDER BY i.upload_date DESC LIMIT 1";
        return connector.getConnection().createStatement().executeQuery(sql);
    }

    public void close() {
        connector.closeConnection();
    }
}
