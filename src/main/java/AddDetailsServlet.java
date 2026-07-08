import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBConnection;

@WebServlet("/adddetails")
public class AddDetailsServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String reg = req.getParameter("reg");
        String college = req.getParameter("college");
        String department = req.getParameter("department");
        String semester = req.getParameter("semester");
        String section = req.getParameter("section");
        String dob = req.getParameter("dob");
        String blood = req.getParameter("blood");
        String gender = req.getParameter("gender");
        String mobile = req.getParameter("mobile");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String category = req.getParameter("category");
        String nationality = req.getParameter("nationality");
        String year = req.getParameter("year");
        String parentName = req.getParameter("parentName");
        String parentPhone = req.getParameter("parentPhone");
        String parentBlood = req.getParameter("parentBlood");

        try {
            Connection con = DBConnection.getConnection();

            // Get correct student name from students table
            String studentName = "";
            PreparedStatement namePs =
                    con.prepareStatement("SELECT fullname FROM students WHERE id=?");
            namePs.setInt(1, id);

            ResultSet nameRs = namePs.executeQuery();

            if (nameRs.next()) {
                studentName = nameRs.getString("fullname");
            } else {
                res.getWriter().println("Student not found");
                return;
            }

            PreparedStatement check =
                    con.prepareStatement("SELECT * FROM student_details WHERE id=?");
            check.setInt(1, id);

            ResultSet rs = check.executeQuery();
            PreparedStatement ps;

            if (rs.next()) {

                String sql =
                        "UPDATE student_details SET reg_no=?, name=?, college_name=?, department=?, semester=?, section=?, dob=?, blood_group=?, gender=?, mobile=?, phone=?, address=?, category=?, nationality=?, admission_year=?, parent_name=?, parent_phone=?, parent_blood_group=? WHERE id=?";

                ps = con.prepareStatement(sql);

                ps.setString(1, reg);
                ps.setString(2, studentName);
                ps.setString(3, college);
                ps.setString(4, department);
                ps.setString(5, semester);
                ps.setString(6, section);
                ps.setString(7, dob);
                ps.setString(8, blood);
                ps.setString(9, gender);
                ps.setString(10, mobile);
                ps.setString(11, phone);
                ps.setString(12, address);
                ps.setString(13, category);
                ps.setString(14, nationality);
                ps.setString(15, year);
                ps.setString(16, parentName);
                ps.setString(17, parentPhone);
                ps.setString(18, parentBlood);
                ps.setInt(19, id);

            } else {

                String sql =
                        "INSERT INTO student_details (id, reg_no, name, college_name, department, semester, section, dob, blood_group, gender, mobile, phone, address, category, nationality, admission_year, parent_name, parent_phone, parent_blood_group) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

                ps = con.prepareStatement(sql);

                ps.setInt(1, id);
                ps.setString(2, reg);
                ps.setString(3, studentName);
                ps.setString(4, college);
                ps.setString(5, department);
                ps.setString(6, semester);
                ps.setString(7, section);
                ps.setString(8, dob);
                ps.setString(9, blood);
                ps.setString(10, gender);
                ps.setString(11, mobile);
                ps.setString(12, phone);
                ps.setString(13, address);
                ps.setString(14, category);
                ps.setString(15, nationality);
                ps.setString(16, year);
                ps.setString(17, parentName);
                ps.setString(18, parentPhone);
                ps.setString(19, parentBlood);
            }

            ps.executeUpdate();

            rs.close();
            check.close();
            nameRs.close();
            namePs.close();
            ps.close();
            con.close();

            res.sendRedirect("details.jsp?id=" + id);

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println(e);
        }
    }
}