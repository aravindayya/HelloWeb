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

@WebServlet("/saveattendance")
public class SaveAttendanceServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String semester = req.getParameter("semester");
        String section = req.getParameter("section");
        String department = req.getParameter("department");
        String date = req.getParameter("date");

        HttpSession session = req.getSession();
        String teacher = (String) session.getAttribute("teacher");

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement psStudents = con.prepareStatement(
                "SELECT id,student_code FROM student_details WHERE semester=? AND section=? AND department=?"
            );

            psStudents.setString(1, semester);
            psStudents.setString(2, section);
            psStudents.setString(3, department);

            ResultSet rs = psStudents.executeQuery();

            while(rs.next()){

                int id = rs.getInt("id");
                String studentCode = rs.getString("student_code");

                String status = req.getParameter("status_" + studentCode);

                if(status==null){
                    continue;
                }

                PreparedStatement check = con.prepareStatement(
                    "SELECT attendance_id FROM attendance WHERE student_code=? AND att_date=?"
                );

                check.setString(1, studentCode);
                check.setString(2, date);

                ResultSet existing = check.executeQuery();

                if(existing.next()){

                    PreparedStatement update = con.prepareStatement(
                        "UPDATE attendance SET status=?,marked_by=?,semester=?,section=?,department=? WHERE student_code=? AND att_date=?"
                    );

                    update.setString(1, status);
                    update.setString(2, teacher);
                    update.setString(3, semester);
                    update.setString(4, section);
                    update.setString(5, department);
                    update.setString(6, studentCode);
                    update.setString(7, date);

                    update.executeUpdate();
                    update.close();

                }else{

                    PreparedStatement insert = con.prepareStatement(
                        "INSERT INTO attendance(student_id,student_code,att_date,status,marked_by,semester,section,department) VALUES(?,?,?,?,?,?,?,?)"
                    );

                    insert.setInt(1, id);
                    insert.setString(2, studentCode);
                    insert.setString(3, date);
                    insert.setString(4, status);
                    insert.setString(5, teacher);
                    insert.setString(6, semester);
                    insert.setString(7, section);
                    insert.setString(8, department);

                    insert.executeUpdate();
                    insert.close();
                }

                existing.close();
                check.close();
            }

            rs.close();
            psStudents.close();
            con.close();

            res.setContentType("text/html");

            PrintWriter out = res.getWriter();

            out.println("<html>");
            out.println("<head>");
            out.println("<script>");
            out.println("alert('Attendance Saved Successfully!');");
            out.println("window.location='attendance.jsp';");
            out.println("</script>");
            out.println("</head>");
            out.println("<body></body>");
            out.println("</html>");

        }catch(Exception e){

            e.printStackTrace();

            res.setContentType("text/html");

            PrintWriter out = res.getWriter();

            out.println("<html>");
            out.println("<head>");
            out.println("<script>");
            out.println("alert('"+e.getMessage().replace("'","")+"');");
            out.println("history.back();");
            out.println("</script>");
            out.println("</head>");
            out.println("<body></body>");
            out.println("</html>");
        }
    }
}