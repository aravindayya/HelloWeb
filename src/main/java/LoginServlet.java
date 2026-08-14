import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.DBConnection;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession oldSession = req.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        String type = req.getParameter("type");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        HttpSession session = req.getSession();
        PrintWriter out = res.getWriter();

        try {
            Connection con = DBConnection.getConnection();

            if (con == null) {
                showAlert(res, out, "Database Connection Failed", "login.jsp");
                return;
            }

            if (type.equals("admin")) {

                PreparedStatement ps = con.prepareStatement(
                        "SELECT * FROM users WHERE username=? AND password=?");
                ps.setString(1, username);
                ps.setString(2, password);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    session.setAttribute("admin", username);
                    session.setAttribute("user", username);
                    session.setAttribute("adminName", rs.getString("name"));
                    res.sendRedirect("index.jsp");
                } else {
                    showAlert(res, out, "Wrong Admin Login", "login.jsp");
                }

                rs.close();
                ps.close();

            } else if (type.equals("teacher")) {

                PreparedStatement ps = con.prepareStatement(
                        "SELECT * FROM teachers WHERE username=? AND password=?");
                ps.setString(1, username);
                ps.setString(2, password);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    session.setAttribute("teacher", username);
                    session.setAttribute("teacherName", rs.getString("fullname"));
                    session.setAttribute("teacherDepartment", rs.getString("department"));
                    session.setAttribute("teacherSemester", rs.getString("semester"));
                    session.setAttribute("teacherSection", rs.getString("section"));
                    session.setAttribute("user", username);
                    res.sendRedirect("attendance.jsp");
                } else {
                    showAlert(res, out, "Wrong Teacher Login", "login.jsp");
                }

                rs.close();
                ps.close();

            } else {

                PreparedStatement ps = con.prepareStatement(
                        "SELECT * FROM students WHERE username=? AND password=?");
                ps.setString(1, username);
                ps.setString(2, password);

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    session.removeAttribute("admin");
                    session.removeAttribute("teacher");

                    session.setAttribute("user", username);
                    session.setAttribute("studentId", rs.getInt("id"));
                    session.setAttribute("studentCode", rs.getString("student_code"));
                    session.setAttribute("name", rs.getString("fullname"));

                    res.sendRedirect("index.jsp");
                } else {
                    showAlert(res, out, "Wrong Username or Password", "login.jsp");
                }

                rs.close();
                ps.close();
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            showAlert(res, out, "Database Error", "login.jsp");
        }
    }

    private void showAlert(HttpServletResponse res, PrintWriter out,
                           String message, String page) throws IOException {
        res.setContentType("text/html");
        out.println("<script>");
        out.println("alert('" + message.replace("'", "") + "');");
        out.println("window.location='" + page + "';");
        out.println("</script>");
    }
}
