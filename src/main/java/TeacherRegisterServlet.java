import java.io.*;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import utils.DBConnection;

@WebServlet("/teacherregister")
public class TeacherRegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req,
                          HttpServletResponse res)
            throws IOException {

        String fullname=req.getParameter("fullname");
        String username=req.getParameter("username");
        String password=req.getParameter("password");
        String adminpass=req.getParameter("adminpass");
        String phone=req.getParameter("phone");
        String email=req.getParameter("email");

        String department=req.getParameter("department");
        String semester=req.getParameter("semester");
        String section=req.getParameter("section");

        if(!adminpass.equals("1234")){
            res.getWriter().println(
                "<script>alert('Wrong Admin Password');window.history.back();</script>"
            );
            return;
        }

        String semNo=semester.substring(0,1);
        int random=1000+(int)(Math.random()*9000);

        String secretCode=
                "TR-"+department+"-"+semNo+section+"-"+random;

        try{
            Connection con=DBConnection.getConnection();

            PreparedStatement ps=con.prepareStatement(
                "INSERT INTO teachers(fullname,username,password,phone,email,department,semester,section,secret_code) VALUES(?,?,?,?,?,?,?,?,?)"
            );

            ps.setString(1,fullname);
            ps.setString(2,username);
            ps.setString(3,password);
            ps.setString(4,phone);
            ps.setString(5,email);
            ps.setString(6,department);
            ps.setString(7,semester);
            ps.setString(8,section);
            ps.setString(9,secretCode);

            ps.executeUpdate();

            res.getWriter().println(
                "<script>alert('Teacher Registered! Secret Code: "
                + secretCode +
                "');window.location='index.jsp';</script>"
            );

            con.close();

        }catch(Exception e){
            e.printStackTrace();
            res.getWriter().println(e);
        }
    }
}