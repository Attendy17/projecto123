package ut.JAR.CPEN410;

import java.sql.*;

public class FriendDAO {
    private MySQLCompleteConnector connector;

    public FriendDAO() {
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }

    /**
     * Busca amigos según filtros opcionales: username, town, gender, edad mínima y máxima.
     * Si un filtro es nulo o vacío, se ignora.
     * Usa LIKE para username y town, y BETWEEN para edad.
     *
     * @param username Nombre de usuario (filtro LIKE).
     * @param town Pueblo (filtro LIKE).
     * @param gender Género exacto.
     * @param minAge Edad mínima.
     * @param maxAge Edad máxima.
     * @return ResultSet con los usuarios encontrados.
     * @throws SQLException si hay error en la base de datos.
     */
    public ResultSet searchFriends(String username, String town, String gender, int minAge, int maxAge) throws SQLException {
        String usernameCondition = "";
        if (username != null && !username.trim().isEmpty()) {
            usernameCondition = " AND users.name LIKE '%" + username.trim() + "%' ";
        }

        String townCondition = "";
        if (town != null && !town.trim().isEmpty()) {
            townCondition = " AND addresses.town LIKE '%" + town.trim() + "%' ";
        }

        String genderCondition = "";
        if (gender != null && !gender.trim().isEmpty()) {
            genderCondition = " AND users.gender = '" + gender.trim() + "' ";
        }

        String sql = "SELECT users.id, users.name, users.email, users.birth_date, users.profile_picture, " +
                     "addresses.street, addresses.town, addresses.state, addresses.country, " +
                     "TIMESTAMPDIFF(YEAR, users.birth_date, CURDATE()) AS age " +
                     "FROM users " +
                     "JOIN addresses ON users.id = addresses.user_id " +
                     "WHERE 1=1 " +
                     usernameCondition +
                     townCondition +
                     genderCondition +
                     "AND TIMESTAMPDIFF(YEAR, users.birth_date, CURDATE()) BETWEEN " + minAge + " AND " + maxAge;

        System.out.println("Friend search query: " + sql);

        Statement stmt = connector.getConnection().createStatement();
        return stmt.executeQuery(sql);
    }

    public void close() {
        connector.closeConnection();
    }
}
