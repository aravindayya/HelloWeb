import java.io.IOException;
import java.sql.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import utils.DBConnection;

@WebServlet("/checkUsername")
public class CheckUsernameServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req,HttpServletResponse res)
            throws IOException{

        String username=req.getParameter("username");

        try{

            Connection con=DBConnection.getConnection();

            PreparedStatement ps=con.prepareStatement(
                "SELECT * FROM students WHERE username=?"
            );

            ps.setString(1,username);

            ResultSet rs=ps.executeQuery();

            if(rs.next()){

                res.getWriter().print("exists");

            }else{

                res.getWriter().print("available");

            }

            rs.close();
            ps.close();
            con.close();

        }catch(Exception e){

            e.printStackTrace();

        }

    }

}