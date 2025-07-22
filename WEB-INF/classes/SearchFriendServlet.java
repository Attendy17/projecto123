import ut.JAR.CPEN410.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * SearchFriendServlet
 * ---------------------
 * Handles user search queries via GET requests.
 *
 * Supported parameters:
 * - q        → unified search by name/email/town (if provided, overrides others)
 * - town     → filter by town
 * - gender   → filter by gender
 * - minAge   → minimum age (required if q is not used)
 * - maxAge   → maximum age (required if q is not used)
 *
 * Returns JSON format:
 * {
 *   "results": [
 *     {
 *       "id": ..., "name": "...", "age": ..., "email": "...",
 *       "town": "...", "profile_picture": "http://..."
 *     },
 *     ...
 *   ]
 * }
 */
public class SearchFriendServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        FriendDAO dao = new FriendDAO();
        ResultSet rs = null;

        try {
            // Determine search mode: unified or filtered
            String q = req.getParameter("q");
            if (q != null && !q.trim().isEmpty()) {
                rs = dao.searchFriends(q.trim());
            } else {
                String town = req.getParameter("town");
                String gender = req.getParameter("gender");
                String minAgeParam = req.getParameter("minAge");
                String maxAgeParam = req.getParameter("maxAge");

                if (minAgeParam == null || maxAgeParam == null) {
                    JSONObject error = new JSONObject();
                    error.put("error", "Missing age parameters");
                    out.print(error.toString());
                    return;
                }

                int minAge = Integer.parseInt(minAgeParam);
                int maxAge = Integer.parseInt(maxAgeParam);

                rs = dao.searchFriends(town, gender, minAge, maxAge);
            }

            JSONArray resultsArray = new JSONArray();

            while (rs.next()) {
                String pic = rs.getString("profile_picture");
                String picUrl = (pic != null && !pic.isEmpty())
                        ? "http://192.168.1.16:8089/" + pic
                        : "";

                JSONObject friend = new JSONObject();
                friend.put("id", rs.getLong("id"));
                friend.put("name", rs.getString("name"));
                friend.put("age", rs.getInt("age"));
                friend.put("email", rs.getString("email"));
                friend.put("town", rs.getString("town"));
                friend.put("profile_picture", picUrl);

                resultsArray.put(friend);
            }

            JSONObject response = new JSONObject();
            response.put("results", resultsArray);

            out.print(response.toString());

        } catch (NumberFormatException e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", "Invalid age format");
            out.print(error.toString());
        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", "Server error");
            out.print(error.toString());
        } finally {
            dao.close();
        }
    }
}
