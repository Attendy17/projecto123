package ut.JAR.CPEN410;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * PersonalInfoDAO
 * ----------------
 * Inserts <strong>address</strong> and <strong>education</strong> rows
 * associated with a user.  All SQL strings are built by concatenation and
 * executed through {@link MySQLCompleteConnector#doInsert} (no
 * PreparedStatement parameters).
 */
public class PersonalInfoDAO {

    /** Keeps the JDBC connection open. */
    private final MySQLCompleteConnector connector;

    /** Opens the connection at construction time. */
    public PersonalInfoDAO() {
        System.out.println("PersonalInfoDAO loaded.");
        connector = new MySQLCompleteConnector();
        connector.doConnection();
    }

    /*  address */

    /**
     * Stores a row in <code>addresses</code> linked to <code>userId</code>.
     * @return {@code true} when the insertion succeeds.
     */
    public boolean addAddress(long userId,
                              String street,
                              String town,
                              String state,
                              String country) {
        // basic quote‑escaping to avoid syntax breakage
        street  = street.replace("'", "''");
        town    = town.replace("'", "''");
        state   = state.replace("'", "''");
        country = country.replace("'", "''");

        String cols  = "addresses(user_id,street,town,state,country)";
        String vals  = userId + ", '" + street + "', '" + town + "', '" + state + "', '" + country + "'";
        boolean err  = connector.doInsert(cols, vals);
        return !err;                  // false → success
    }

    /* education */

    /**
     * Stores a row in <code>education</code> linked to <code>userId</code>.
     * Escapes apostrophes to keep the SQL valid.
     */
    public boolean addEducation(long userId,
                                String degree,
                                String school) {
        degree = degree.replace("'", "''");
        school = school.replace("'", "''");

        String cols = "education(user_id,degree,school)";
        String vals = userId + ", '" + degree + "', '" + school + "'";
        boolean err = connector.doInsert(cols, vals);
        return !err;
    }

    /** Closes the underlying JDBC connection. */
    public void close() {
        connector.closeConnection();
    }
}
