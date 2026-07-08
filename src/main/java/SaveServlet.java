import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/save")
public class SaveServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String msg = req.getParameter("msg");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO messages(text) VALUES(?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, msg);

            ps.executeUpdate();

            PrintWriter out = res.getWriter();
            out.println("<html>");
            out.println("<body>");
            out.println("<script>");
            out.println("alert('Student Added');");
            out.println("window.location='index.jsp';");
            out.println("</script>");
            out.println("</body>");
            out.println("</html>");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}