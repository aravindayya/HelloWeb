import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import utils.DBConnection;

@WebServlet("/delete")
public class DeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String studentCode = req.getParameter("code");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps0 =
                con.prepareStatement("DELETE FROM attendance WHERE student_code=?");
            ps0.setString(1, studentCode);
            ps0.executeUpdate();

            PreparedStatement ps1 =
                con.prepareStatement("DELETE FROM student_details WHERE student_code=?");
            ps1.setString(1, studentCode);
            ps1.executeUpdate();

            PreparedStatement ps2 =
                con.prepareStatement("DELETE FROM marks_card WHERE student_code=?");
            ps2.setString(1, studentCode);
            ps2.executeUpdate();

            PreparedStatement ps3 =
                con.prepareStatement("DELETE FROM students WHERE student_code=?");
            ps3.setString(1, studentCode);

            int rows = ps3.executeUpdate();

            if(rows > 0){
                res.sendRedirect("index.jsp");
            }else{
                res.getWriter().println("Student not found");
            }

            ps0.close();
            ps1.close();
            ps2.close();
            ps3.close();
            con.close();

        } catch(Exception e) {
            e.printStackTrace();
            res.getWriter().println(e);
        }
    }
}