import java.io.*;
import java.sql.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
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

            if (type.equals("admin")) {

                if (username.equals("aruaru") && password.equals("Aru@172737")) {

                    session.setAttribute("admin", username);
                    session.setAttribute("user", username);

                    res.sendRedirect("index.jsp");

                } else {
                    out.println("<script>");
                    out.println("alert('Wrong Admin Login');");
                    out.println("window.location='login.jsp';");
                    out.println("</script>");
                }
            }

            else if (type.equals("teacher")) {

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
                    out.println("<script>");
                    out.println("alert('Wrong Teacher Login');");
                    out.println("window.location='login.jsp';");
                    out.println("</script>");
                }
            }

            else {

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
                    out.println("<script>");
                    out.println("alert('Wrong Username or Password');");
                    out.println("window.location='login.jsp';");
                    out.println("</script>");
                }
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();

            out.println("<script>");
            out.println("alert('Database Error');");
            out.println("window.location='login.jsp';");
            out.println("</script>");
        }
    }
}