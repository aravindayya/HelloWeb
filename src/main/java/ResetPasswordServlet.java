import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/resetpassword")
public class ResetPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String newPass = req.getParameter("newpass");
        String confirmPass = req.getParameter("confirmpass");

        HttpSession session = req.getSession();
        String username = (String) session.getAttribute("resetUser");

        if (!newPass.equals(confirmPass)) {
            PrintWriter out = res.getWriter();
            out.println("<script>");
            out.println("alert('Passwords do not match');");
            out.println("window.location='resetpassword.jsp';");
            out.println("</script>");
            return;
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE students SET password=? WHERE username=?"
            );

            ps.setString(1, newPass);
            ps.setString(2, username);

            int rows = ps.executeUpdate();

            System.out.println("Username = " + username);
            System.out.println("Rows Updated = " + rows);

            PrintWriter out = res.getWriter();

            if (rows > 0) {

                session.removeAttribute("otp");
                session.removeAttribute("resetUser");

                out.println("<script>");
                out.println("alert('Password Updated Successfully');");
                out.println("window.location='login.jsp';");
                out.println("</script>");

            } else {

                out.println("<script>");
                out.println("alert('Update Failed');");
                out.println("window.location='resetpassword.jsp';");
                out.println("</script>");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println(e);
        }
    }
}