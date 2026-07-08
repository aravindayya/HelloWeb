import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/update")
public class UpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String fullname = req.getParameter("msg");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE students SET fullname=? WHERE id=?"
            );

            ps.setString(1, fullname);
            ps.setInt(2, id);

            int rows = ps.executeUpdate();

            res.setContentType("text/html");
            PrintWriter out = res.getWriter();

            if(rows > 0){
                res.sendRedirect("index.jsp");
            } else {
                out.println("No student updated");
            }

            con.close();

        } catch(Exception e) {
            e.printStackTrace();
            res.getWriter().println(e);
        }
    }
}