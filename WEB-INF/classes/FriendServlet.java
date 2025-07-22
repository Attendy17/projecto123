
import ut.JAR.CPEN410.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import org.json.JSONObject;

/**
 * FriendServlet
 * -------------
 * Handles friend request submissions via POST.
 *
 * POST Parameters:
 *   - user1 = sender's user ID
 *   - user2 = recipient's user ID
 *
 * JSON Responses:
 *   - { "status": "sent" }             request sent successfully
 *   - { "status": "exists" }           friendship or request already exists
 *   - { "status": "missing_params" }   required parameters not provided
 *   - { "status": "error" }            unexpected server error
 */
public class FriendServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();
        JSONObject response = new JSONObject();

        try {
            // Retrieve sender and receiver IDs from POST parameters
            String user1Param = req.getParameter("user1");
            String user2Param = req.getParameter("user2");

            if (user1Param == null || user2Param == null) {
                response.put("status", "missing_params");
                out.print(response.toString());
                return;
            }

            long user1Id = Long.parseLong(user1Param);
            long user2Id = Long.parseLong(user2Param);

            System.out.println("[FriendServlet] Sending friend request from " + user1Id + " to " + user2Id);

            // Attempt to send the friend request
            FriendshipDAO dao = new FriendshipDAO();
            boolean sent = dao.sendFriendRequest(user1Id, user2Id);
            dao.close();

            if (sent) {
                response.put("status", "sent");
            } else {
                response.put("status", "exists");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
        }

        out.print(response.toString());
    }
}
