package ut.JAR.CPEN410;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * AdminDAO
 * --------
 * Clase utilitaria para realizar operaciones administrativas
 * relacionadas con usuarios y fotos.
 *
 * Todas las consultas SQL se construyen por concatenación directa
 * y se ejecutan usando métodos de MySQLCompleteConnector.
 */
public class AdminDAO {

    /** Conector de base de datos */
    private final MySQLCompleteConnector connector;

    /** Constructor: abre la conexión al instanciar */
    public AdminDAO() {
        System.out.println("AdminDAO loaded.");
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }

    // ─────────────────────── Métodos auxiliares ───────────────────────

    /**
     * Verifica si el correo electrónico ya está registrado.
     */
    private boolean emailExists(String email) throws SQLException {
        ResultSet rs = connector.doSelect("id", "users", "email='" + email + "'");
        boolean found = rs.next();
        rs.close();
        return found;
    }

    /**
     * Obtiene el ID de un rol. Si no existe, lo crea.
     */
    private int getOrCreateRole(String roleName) {
        try {
            ResultSet rs = connector.doSelect("id", "roles", "name='" + roleName + "'");
            if (rs.next()) {
                int id = rs.getInt("id");
                rs.close();
                return id;
            }
            rs.close();

            // Insertar nuevo rol si no existe
            if (!connector.doInsert("roles(name)", "'" + roleName + "'")) {
                ResultSet rs2 = connector.doSelect("id", "roles", "name='" + roleName + "'");
                if (rs2.next()) {
                    int id = rs2.getInt("id");
                    rs2.close();
                    return id;
                }
                rs2.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ─────────────────────── API pública ───────────────────────

    /**
     * Lista todos los usuarios con sus datos de perfil público.
     */
    public ResultSet listUsers() throws SQLException {
        return connector.doSelect(
            "id, name, email, birth_date, gender, profile_picture",
            "users",
            "1=1"
        );
    }

    /**
     * Crea un nuevo usuario con su respectivo rol.
     *
     * @return true si todo se inserta correctamente
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

            // Insertar en tabla users
            String userVals = "'" + name + "', '" + email + "', SHA2('"
                            + password + "',256), '" + birthDate + "', '"
                            + gender + "', NULL, NULL";

            boolean userErr = connector.doInsert(
                "users(name,email,password,birth_date,gender,profile_picture,last_page_id)",
                userVals
            );

            if (userErr) return false;

            // Obtener el ID del usuario recién insertado
            ResultSet rs = connector.doSelect(
                "id", "users",
                "email='" + email + "' ORDER BY id DESC LIMIT 1"
            );
            if (!rs.next()) {
                rs.close();
                return false;
            }

            long userId = rs.getLong("id");
            rs.close();

            // Insertar rol
            int roleId = getOrCreateRole(isAdmin ? "ADMIN" : "USER");
            if (roleId == -1) return false;

            boolean roleErr = connector.doInsert(
                "user_roles(user_id,role_id)",
                userId + ", " + roleId
            );

            return !roleErr; // false significa que todo salió bien

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualiza datos básicos del usuario.
     */
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
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Verifica si el usuario tiene el rol ADMIN.
     */
    public boolean isAdmin(long userId) {
        try {
            ResultSet rs = connector.doSelect(
                "r.name",
                "roles r, user_roles ur",
                "r.id = ur.role_id AND ur.user_id = " + userId
            );
            while (rs.next()) {
                if ("ADMIN".equalsIgnoreCase(rs.getString("name"))) {
                    rs.close();
                    return true;
                }
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Elimina un usuario por ID.
     */
    public boolean deleteUser(long id) {
        String sql = "DELETE FROM users WHERE id=" + id;
        try {
            return connector.getConnection()
                            .createStatement()
                            .executeUpdate(sql) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─────────────────────── Fotos ───────────────────────

    /**
     * Lista todas las fotos del usuario (más recientes primero).
     */
    public ResultSet getUserPhotos(long userId) throws SQLException {
        return connector.doSelect(
            "id, image_url, upload_date",
            "images",
            "user_id=" + userId + " ORDER BY upload_date DESC"
        );
    }

    /**
     * Elimina una foto por su ID.
     */
    public boolean deletePhoto(long photoId) {
        String sql = "DELETE FROM images WHERE id=" + photoId;
        try {
            return connector.getConnection()
                            .createStatement()
                            .executeUpdate(sql) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualiza la foto de perfil del usuario.
     */
    public boolean updateUserProfilePicture(long id, String pic) {
        String sql = "UPDATE users SET profile_picture='" + pic + "' WHERE id=" + id;
        try {
            return connector.getConnection()
                            .createStatement()
                            .executeUpdate(sql) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Devuelve la fila del usuario con ese ID.
     */
    public ResultSet getUserById(long id) throws SQLException {
        return connector.doSelect(
            "id, name, email, birth_date, gender, profile_picture",
            "users",
            "id=" + id
        );
    }

    /**
     * Cierra la conexión a la base de datos.
     */
    public void close() {
        connector.closeConnection();
    }
}
