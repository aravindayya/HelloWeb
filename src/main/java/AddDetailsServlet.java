import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.DBConnection;

@WebServlet("/adddetails")
public class AddDetailsServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        boolean isAdmin = session.getAttribute("admin") != null;
        boolean isTeacher = session.getAttribute("teacher") != null;
        String sessionStudentCode = (String) session.getAttribute("studentCode");

        String studentCode = req.getParameter("studentCode");

        // Only admin/teacher can edit any student; students can edit only their own record
        if (!isAdmin && !isTeacher &&
            (sessionStudentCode == null || !sessionStudentCode.equals(studentCode))) {
            res.sendRedirect("index.jsp");
            return;
        }

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

            // Resolve the student id + name from the students table
            PreparedStatement studentPs =
                con.prepareStatement("SELECT id, fullname FROM students WHERE student_code=?");
            studentPs.setString(1, studentCode);

            ResultSet studentRs = studentPs.executeQuery();

            if (!studentRs.next()) {
                res.getWriter().println("Student not found");
                studentRs.close();
                studentPs.close();
                con.close();
                return;
            }

            int id = studentRs.getInt("id");
            String studentName = studentRs.getString("fullname");

            PreparedStatement check =
                con.prepareStatement("SELECT id FROM student_details WHERE id=?");
            check.setInt(1, id);

            ResultSet rs = check.executeQuery();
            PreparedStatement ps;

            if (rs.next()) {

                String sql =
                    "UPDATE student_details SET student_code=?, reg_no=?, name=?, college_name=?, " +
                    "department=?, semester=?, section=?, dob=?, blood_group=?, gender=?, mobile=?, " +
                    "phone=?, address=?, category=?, nationality=?, admission_year=?, parent_name=?, " +
                    "parent_phone=?, parent_blood_group=? WHERE id=?";

                ps = con.prepareStatement(sql);

                ps.setString(1, studentCode);
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
                ps.setInt(20, id);

            } else {

                String sql =
                    "INSERT INTO student_details (id, student_code, reg_no, name, college_name, " +
                    "department, semester, section, dob, blood_group, gender, mobile, phone, address, " +
                    "category, nationality, admission_year, parent_name, parent_phone, parent_blood_group) " +
                    "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

                ps = con.prepareStatement(sql);

                ps.setInt(1, id);
                ps.setString(2, studentCode);
                ps.setString(3, reg);
                ps.setString(4, studentName);
                ps.setString(5, college);
                ps.setString(6, department);
                ps.setString(7, semester);
                ps.setString(8, section);
                ps.setString(9, dob);
                ps.setString(10, blood);
                ps.setString(11, gender);
                ps.setString(12, mobile);
                ps.setString(13, phone);
                ps.setString(14, address);
                ps.setString(15, category);
                ps.setString(16, nationality);
                ps.setString(17, year);
                ps.setString(18, parentName);
                ps.setString(19, parentPhone);
                ps.setString(20, parentBlood);
            }

            ps.executeUpdate();

            rs.close();
            check.close();
            studentRs.close();
            studentPs.close();
            ps.close();
            con.close();

            res.sendRedirect("details.jsp?code=" + studentCode);

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println(e);
        }
    }
}
