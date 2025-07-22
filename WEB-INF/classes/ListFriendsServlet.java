import ut.JAR.CPEN410.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.time.*;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 * ListFriendsServlet
 * ------------------
 * Handles two main functions:
 *
 * 1. Accept a pending friend request:
 *    GET /ListFriendsServlet?action=accept&friendshipId={id}
 *     { "success": true | false }
 *
 * 2. List a user's accepted friends and incoming friend requests:
 *    GET /ListFriendsServlet?userId={id}
 *     {
 *         "friends": [ ... ],
 *         "requests": [ ... ]
 *       }
 */
public class ListFriendsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        String action = req.getParameter("action");

        try {
            // 1. Accept a pending friend request
            if ("accept".equalsIgnoreCase(action)) {
                String fidStr = req.getParameter("friendshipId");
                if (fidStr == null) {
                    JSONObject error = new JSONObject();
                    error.put("error", "Missing friendshipId");
                    out.print(error.toString());
                    return;
                }

                long fid = Long.parseLong(fidStr);
                FriendshipDAO dao = new FriendshipDAO();
                boolean success = dao.acceptFriendRequest(fid);
                dao.close();

                JSONObject result = new JSONObject();
                result.put("success", success);
                out.print(result.toString());
                return;
            }

            // 2. List friends and pending requests
            String userIdStr = req.getParameter("userId");
            if (userIdStr == null || userIdStr.trim().isEmpty()) {
                JSONObject error = new JSONObject();
                error.put("error", "Missing userId");
                out.print(error.toString());
                return;
            }

            long userId = Long.parseLong(userIdStr);
            System.out.println("Requesting data for userId: " + userId);

            FriendshipDAO dao = new FriendshipDAO();

            // Build friend list
            JSONArray friendsArray = new JSONArray();
            ResultSet rsFriends = dao.listFriends(userId);

            while (rsFriends.next()) {
                long friendId = (rsFriends.getLong("user1_id") == userId)
                        ? rsFriends.getLong("user2_id")
                        : rsFriends.getLong("user1_id");

                ProfileDAO profileDAO = new ProfileDAO();
                ResultSet profile = profileDAO.getUserProfile(friendId);

                if (profile.next()) {
                    JSONObject friendObj = new JSONObject();
                    friendObj.put("name", profile.getString("name"));
                    friendObj.put("age", calculateAge(profile.getDate("birth_date")));
                    friendObj.put("profile_picture", buildPicUrl(profile.getString("profile_picture")));

                    friendsArray.put(friendObj);
                }
                profileDAO.close();
            }

            // Build pending request list
            JSONArray requestsArray = new JSONArray();
            ResultSet rsRequests = dao.listIncomingRequests(userId);

            while (rsRequests.next()) {
                long senderId = rsRequests.getLong("user1_id");
                long requestId = rsRequests.getLong("id");

                ProfileDAO profileDAO = new ProfileDAO();
                ResultSet profile = profileDAO.getUserProfile(senderId);

                if (profile.next()) {
                    JSONObject requestObj = new JSONObject();
                    requestObj.put("friendship_id", requestId);
                    requestObj.put("name", profile.getString("name"));
                    requestObj.put("age", calculateAge(profile.getDate("birth_date")));
                    requestObj.put("profile_picture", buildPicUrl(profile.getString("profile_picture")));

                    requestsArray.put(requestObj);
                }
                profileDAO.close();
            }

            dao.close();

            // Build final response
            JSONObject response = new JSONObject();
            response.put("friends", friendsArray);
            response.put("requests", requestsArray);

            out.print(response.toString());

        } catch (Exception e) {
            e.printStackTrace();
            JSONObject error = new JSONObject();
            error.put("error", "Server error");
            out.print(error.toString());
        }
    }

    private int calculateAge(java.sql.Date birth) {
        if (birth == null) return 0;
        LocalDate birthDate = birth.toLocalDate();
        return Period.between(birthDate, LocalDate.now()).getYears();
    }

    private String buildPicUrl(String pic) {
        return (pic != null && !pic.isEmpty()) ? "http://192.168.1.16:8089/" + pic : "";
    }
}
