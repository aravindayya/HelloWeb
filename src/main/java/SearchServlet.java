import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import utils.DBConnection;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String search = req.getParameter("search");

        try{
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM students WHERE student_code=? OR fullname LIKE ?"
            );

            ps.setString(1, search);
            ps.setString(2, "%" + search + "%");

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                String studentCode = rs.getString("student_code");
                res.sendRedirect("details.jsp?code=" + studentCode);
            }else{
                HttpSession session = req.getSession();
                session.setAttribute("searchError", "Student Not Found");
                res.sendRedirect("index.jsp");
            }

            rs.close();
            ps.close();
            con.close();

        }catch(Exception e){
            e.printStackTrace();
        }
    }
}