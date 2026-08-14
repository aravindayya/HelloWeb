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

@WebServlet("/teacherregister")
public class TeacherRegisterServlet extends HttpServlet {

    private String generateSecretCode(String department, String semester,
                                      String section) {
        String semNo = semester.replaceAll("\\D", "");
        if (semNo.equals("")) semNo = "0";
        int random = 100 + (int) (Math.random() * 900);
        return "TR-" + department + "-" + semNo + section + "-" + random;
    }

    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws IOException {

        String fullname = req.getParameter("fullname");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");
        String adminpass = req.getParameter("adminpass");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String department = req.getParameter("department");
        String semester = req.getParameter("semester");
        String section = req.getParameter("section");

        res.setContentType("text/html");
        PrintWriter out = res.getWriter();

        if (!password.equals(confirm)) {
            out.println("<script>alert('Password mismatch');window.history.back();</script>");
            return;
        }

        try {
            Connection con = DBConnection.getConnection();

            // Only a logged-in admin can register teachers.
            // adminpass must match the logged-in admin's password.
            HttpSession session = req.getSession();
            String adminUsername = (String) session.getAttribute("admin");

            boolean adminOk = false;

            if (adminUsername != null) {
                PreparedStatement adminPs = con.prepareStatement(
                        "SELECT password FROM users WHERE username=?");
                adminPs.setString(1, adminUsername);
                ResultSet adminRs = adminPs.executeQuery();

                if (adminRs.next()) {
                    adminOk = adminRs.getString("password").equals(adminpass);
                }

                adminRs.close();
                adminPs.close();
            }

            if (!adminOk) {
                out.println("<script>alert('Invalid Admin Password or Session');window.history.back();</script>");
                con.close();
                return;
            }

            // Username must be unique
            PreparedStatement checkUser = con.prepareStatement(
                    "SELECT id FROM teachers WHERE username=?");
            checkUser.setString(1, username);
            ResultSet userRs = checkUser.executeQuery();

            if (userRs.next()) {
                out.println("<script>alert('Username already exists');window.history.back();</script>");
                userRs.close();
                checkUser.close();
                con.close();
                return;
            }

            userRs.close();
            checkUser.close();

            // Generate a unique secret code
            String secretCode;
            boolean exists;
            do {
                secretCode = generateSecretCode(department, semester, section);

                PreparedStatement codePs = con.prepareStatement(
                        "SELECT id FROM teachers WHERE secret_code=?");
                codePs.setString(1, secretCode);
                ResultSet codeRs = codePs.executeQuery();
                exists = codeRs.next();

                codeRs.close();
                codePs.close();
            } while (exists);

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO teachers(fullname,username,password,phone,email,department,semester,section,secret_code) " +
                "VALUES(?,?,?,?,?,?,?,?,?)");

            ps.setString(1, fullname);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, email);
            ps.setString(6, department);
            ps.setString(7, semester);
            ps.setString(8, section);
            ps.setString(9, secretCode);

            int rows = ps.executeUpdate();

            ps.close();
            con.close();

            if (rows > 0) {
                out.println(
                    "<script>alert('Teacher Registered! Secret Code: "
                    + secretCode +
                    "');window.location='index.jsp';</script>");
            } else {
                out.println("<script>alert('Registration Failed');window.history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println(e);
        }
    }
}
