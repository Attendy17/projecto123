import ut.JAR.CPEN410.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * ProfileServlet
 * --------------
 * Handles fetching recent posts (images) from friends with accepted status.
 *
 * Expected POST parameters:
 *   - userId=### → the ID of the user requesting the feed
 *
 * Returns:
 * {
 *   "posts": [
 *     { "name": "...", "upload_date": "...", "image_url": "..." },
 *     ...
 *   ]
 * }
 */
public class ProfileServlet extends HttpServlet {

    private static final String BASE_URL = "http://192.168.1.16:8089/";

    @Override
    public void init() {
        System.out.println("[ProfileServlet] loaded.");
    }

    /**
     * GET method is not supported for fetching posts.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/plain");
        resp.getWriter().println("Use POST with userId to fetch friend posts.");
    }

    /**
     * POST method: retrieves recent posts from accepted friends.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String userIdStr = req.getParameter("userId");
        PrintWriter out = resp.getWriter();

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            JSONObject error = new JSONObject();
            error.put("error", "Missing userId");
            out.print(error.toString());
            return;
        }

        try {
            long userId = Long.parseLong(userIdStr);
            ProfileDAO dao = new ProfileDAO();
            ResultSet rs = dao.getFriendPhotos(userId);

            JSONArray postsArray = new JSONArray();

            while (rs.next()) {
                String imagePath = rs.getString("image_url");
                String fullUrl = (imagePath != null && imagePath.startsWith("http"))
                        ? imagePath
                        : BASE_URL + imagePath;

                JSONObject post = new JSONObject();
                post.put("name", rs.getString("name"));
                post.put("upload_date", rs.getString("upload_date"));
                post.put("image_url", fullUrl);

                postsArray.put(post);
            }

            JSONObject response = new JSONObject();
            response.put("posts", postsArray);

            dao.close();
            out.print(response.toString());
            System.out.println("[ProfileServlet] Sent friend posts for user " + userId);

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", "Server error");
            out.print(error.toString());
        }
    }
}
