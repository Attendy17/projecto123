/************************************************************
 *  CPEN410  MiniFacebook  Authentication Service
 * ----------------------------------------------------------
 *  POST  user=<email>&pass=<plaintext>
 *   "not"                   invalid credentials
 *    JSON object             valid credentials
 ***********************************************************/

import ut.JAR.CPEN410.*;
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.json.JSONObject;

public class sessionServlet extends HttpServlet {

    @Override
    public void init() {
        System.out.println("[sessionServlet] loaded");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("Use POST to authenticate.");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String email = req.getParameter("user");
        String pass  = req.getParameter("pass");

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        if (email == null || pass == null) {
            out.print("\"not\"");
            return;
        }

        applicationDBAuthenticationGoodComplete dao =
                new applicationDBAuthenticationGoodComplete();

        try (ResultSet rs = dao.authenticate(email, pass)) {
            if (rs == null || !rs.next()) {
                out.print("\"not\"");
                System.out.println("[sessionServlet] FAIL " + email);
            } else {
                String id   = rs.getString("id");
                String name = rs.getString("name");
                String mail = rs.getString("email");

                // Build the JSON response using JSONObject
                JSONObject json = new JSONObject();
                json.put("id", id);
                json.put("name", name);
                json.put("userName", ""); // For compatibility
                json.put("email", mail);

                out.print(json.toString());
                System.out.println("[sessionServlet] OK " + email + " → JSON sent");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            out.print("\"not\"");
        } finally {
            dao.close();
        }
    }
}
