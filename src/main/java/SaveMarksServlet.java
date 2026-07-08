import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBConnection;

@WebServlet("/savemarks")
public class SaveMarksServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String studentCode = req.getParameter("studentCode");

        int s1 = Integer.parseInt(req.getParameter("sub1"));
        int s2 = Integer.parseInt(req.getParameter("sub2"));
        int s3 = Integer.parseInt(req.getParameter("sub3"));
        int s4 = Integer.parseInt(req.getParameter("sub4"));
        int s5 = Integer.parseInt(req.getParameter("sub5"));
        int s6 = Integer.parseInt(req.getParameter("sub6"));

        try {
            Connection con = DBConnection.getConnection();

            int studentId = 0;

            PreparedStatement studentPs = con.prepareStatement(
                "SELECT id FROM students WHERE student_code=?"
            );
            studentPs.setString(1, studentCode);

            ResultSet studentRs = studentPs.executeQuery();

            if(studentRs.next()){
                studentId = studentRs.getInt("id");
            }else{
                res.getWriter().println("Student not found");
                return;
            }

            PreparedStatement check =
                con.prepareStatement(
                    "SELECT student_code FROM marks_card WHERE student_code=?"
                );
            check.setString(1, studentCode);

            ResultSet rs = check.executeQuery();

            if(rs.next()){

                PreparedStatement update = con.prepareStatement(
                    "UPDATE marks_card SET sub1=?,sub2=?,sub3=?,sub4=?,sub5=?,sub6=? WHERE student_code=?"
                );

                update.setInt(1, s1);
                update.setInt(2, s2);
                update.setInt(3, s3);
                update.setInt(4, s4);
                update.setInt(5, s5);
                update.setInt(6, s6);
                update.setString(7, studentCode);

                update.executeUpdate();
                update.close();

            } else {

                PreparedStatement insert = con.prepareStatement(
                    "INSERT INTO marks_card(id,student_code,sub1,sub2,sub3,sub4,sub5,sub6) VALUES(?,?,?,?,?,?,?,?)"
                );

                insert.setInt(1, studentId);
                insert.setString(2, studentCode);
                insert.setInt(3, s1);
                insert.setInt(4, s2);
                insert.setInt(5, s3);
                insert.setInt(6, s4);
                insert.setInt(7, s5);
                insert.setInt(8, s6);

                insert.executeUpdate();
                insert.close();
            }

            rs.close();
            check.close();
            studentRs.close();
            studentPs.close();
            con.close();

            res.sendRedirect("marks.jsp?code=" + studentCode);

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println(e);
        }
    }
}