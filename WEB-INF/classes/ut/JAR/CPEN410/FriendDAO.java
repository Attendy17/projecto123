package ut.JAR.CPEN410;

import java.sql.*;

/**
 * FriendDAO provides methods for searching friends.
 */
public class FriendDAO {
    private MySQLCompleteConnector connector;
    
    public FriendDAO() {
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }
    
    // Método original (por town, gender, edad) se mantiene...
    public ResultSet searchFriends(String town, String gender, int minAge, int maxAge) throws SQLException {
        String townCondition = "";
        if (town != null && !town.trim().isEmpty()) {
            townCondition = " AND a.town LIKE '%" + town.trim() + "%' ";
        }
        
        String genderCondition = "";
        if (gender != null && !gender.trim().isEmpty()) {
            genderCondition = " AND u.gender = '" + gender.trim() + "' ";
        }
        
        String sql = "SELECT u.id, u.name, u.email, u.birth_date, u.profile_picture, " +
                     "a.street, a.town, a.state, a.country, " +
                     "TIMESTAMPDIFF(YEAR, u.birth_date, CURDATE()) AS age " +
                     "FROM users u " +
                     "JOIN addresses a ON u.id = a.user_id " +
                     "WHERE 1=1 " + townCondition + genderCondition +
                     "AND TIMESTAMPDIFF(YEAR, u.birth_date, CURDATE()) BETWEEN " + minAge + " AND " + maxAge;
        
        System.out.println("Friend search query: " + sql);
        
        Statement stmt = connector.getConnection().createStatement();
        return stmt.executeQuery(sql);
    }
    
    /**
     * Búsqueda de amigos utilizando una única cadena de búsqueda.
     * Se realiza una comparación parcial (LIKE) en el nombre y en los campos de ubicación.
     *
     * @param searchQuery La cadena de búsqueda ingresada por el usuario.
     * @return ResultSet con los datos de los usuarios encontrados.
     * @throws SQLException si ocurre un error de conexión o consulta.
     */
    public ResultSet searchFriends(String searchQuery) throws SQLException {
        String sql = "SELECT u.id, u.name, u.email, u.birth_date, u.profile_picture, " +
                     "a.street, a.town, a.state, a.country, " +
                     "TIMESTAMPDIFF(YEAR, u.birth_date, CURDATE()) AS age " +
                     "FROM users u " +
                     "JOIN addresses a ON u.id = a.user_id " +
                     "WHERE REPLACE(LOWER(u.name), ' ', '') LIKE CONCAT('%', REPLACE(LOWER(?), ' ', ''), '%') " +
                     "OR REPLACE(LOWER(a.town), ' ', '') LIKE CONCAT('%', REPLACE(LOWER(?), ' ', ''), '%') " +
                     "OR REPLACE(LOWER(a.state), ' ', '') LIKE CONCAT('%', REPLACE(LOWER(?), ' ', ''), '%') " +
                     "OR REPLACE(LOWER(a.country), ' ', '') LIKE CONCAT('%', REPLACE(LOWER(?), ' ', ''), '%')";
        PreparedStatement stmt = connector.getConnection().prepareStatement(sql);
        // Se usa el mismo parámetro para las cuatro condiciones.
        stmt.setString(1, searchQuery);
        stmt.setString(2, searchQuery);
        stmt.setString(3, searchQuery);
        stmt.setString(4, searchQuery);
        return stmt.executeQuery();
    }
    
    
    public void close() {
        connector.closeConnection();
    }
}
