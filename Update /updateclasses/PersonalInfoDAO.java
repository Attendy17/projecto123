package ut.JAR.CPEN410;

public class PersonalInfoDAO {

    /** Conector para la base de datos */
    private final MySQLCompleteConnector connector;

    /** Constructor: establece la conexión */
    public PersonalInfoDAO() {
        System.out.println("PersonalInfoDAO loaded.");
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }

    /**
     * Inserta una dirección en la tabla `addresses`.
     *
     * @param userId  ID del usuario.
     * @param street  Calle.
     * @param town    Ciudad.
     * @param state   Estado.
     * @param country País.
     * @return true si la inserción fue exitosa.
     */
    public boolean addAddress(long userId, String street, String town, String state, String country) {
        boolean res;
        String table = "addresses";
        String columns = "(user_id, street, town, state, country)";
        String values = "'" + userId + "', '" + street + "', '" + town + "', '" + state + "', '" + country + "'";
        String query = "INSERT INTO " + table + " " + columns + " VALUES (" + values + ")";
        res = connector.doInsert(query);
        System.out.println("Address insertion result: " + res);
        return res;
    }

    /**
     * Inserta una educación en la tabla `education`.
     *
     * @param userId ID del usuario.
     * @param degree Título.
     * @param school Institución.
     * @return true si la inserción fue exitosa.
     */
    public boolean addEducation(long userId, String degree, String school) {
        boolean res;
        String table = "education";
        String columns = "(user_id, degree, school)";
        String values = "'" + userId + "', '" + degree + "', '" + school + "'";
        String query = "INSERT INTO " + table + " " + columns + " VALUES (" + values + ")";
        res = connector.doInsert(query);
        System.out.println("Education insertion result: " + res);
        return res;
    }

    /** Cierra la conexión */
    public void close() {
        connector.closeConnection();
    }
}
