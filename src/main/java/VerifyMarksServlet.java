import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;


@WebServlet("/verifymarks")
public class VerifyMarksServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String password = req.getParameter("password");

        try{
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM student_details WHERE id=? AND password=?"
            );

            ps.setInt(1, id);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
               // res.sendRedirect("details.jsp?id=" + id);
                res.sendRedirect("marks.jsp?id=" + id);
            }else{
                PrintWriter out = res.getWriter();
                out.println("<script>");
                out.println("alert('Wrong Password');");
                out.println("history.back();");
                out.println("</script>");
            }

        }catch(Exception e){
            e.printStackTrace();
        }
    }
}