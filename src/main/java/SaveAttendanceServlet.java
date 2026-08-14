import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

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

        HttpSession session = req.getSession(false);

        if (session == null ||
            (session.getAttribute("teacher") == null && session.getAttribute("admin") == null)) {
            res.sendRedirect("login.jsp");
            return;
        }

        String semester = req.getParameter("semester");
        String section = req.getParameter("section");
        String department = req.getParameter("department");
        String date = req.getParameter("date");

        if (date == null || date.trim().equals("")) {
            res.sendRedirect("attendance.jsp");
            return;
        }

        String markedBy = (String) session.getAttribute("teacherName");
        if (markedBy == null) {
            markedBy = (String) session.getAttribute("adminName");
        }
        if (markedBy == null) {
            markedBy = (String) session.getAttribute("teacher");
        }
        if (markedBy == null) {
            markedBy = (String) session.getAttribute("admin");
        }

        List<String[]> rows = new ArrayList<>();

        Enumeration<String> params = req.getParameterNames();

        while (params.hasMoreElements()) {

            String name = params.nextElement();

            if (name.startsWith("status_")) {

                String studentCode = name.substring(7);
                String status = req.getParameter(name);

                if (status != null) {
                    rows.add(new String[]{studentCode, status});
                }
            }
        }

        Connection con = null;

        try {

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            boolean classFiltered = (semester != null && section != null && department != null);

            PreparedStatement delete;

            if (classFiltered) {

                delete = con.prepareStatement(
                    "DELETE FROM attendance WHERE att_date=? AND semester=? AND section=? AND department=?");
                delete.setString(1, date);
                delete.setString(2, semester);
                delete.setString(3, section);
                delete.setString(4, department);

            } else {

                delete = con.prepareStatement(
                    "DELETE FROM attendance WHERE att_date=? AND student_code=?");
                delete.setString(1, date);
            }

            PreparedStatement insert = con.prepareStatement(
                "INSERT INTO attendance(student_code,att_date,status,marked_by,semester,section,department) VALUES(?,?,?,?,?,?,?)");

            for (String[] row : rows) {

                if (classFiltered) {

                    delete.setString(1, date);
                    delete.setString(2, semester);
                    delete.setString(3, section);
                    delete.setString(4, department);

                } else {

                    delete.setString(2, row[0]);
                }

                delete.executeUpdate();

                insert.setString(1, row[0]);
                insert.setString(2, date);
                insert.setString(3, row[1]);
                insert.setString(4, markedBy);
                insert.setString(5, semester);
                insert.setString(6, section);
                insert.setString(7, department);

                insert.executeUpdate();
            }

            delete.close();
            insert.close();

            con.commit();

            res.sendRedirect("attendance.jsp?date=" + date + "&msg=Attendance+Saved");

        } catch (Exception e) {

            e.printStackTrace();

            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception ex) {
                }
            }

            res.sendRedirect("attendance.jsp?date=" + date + "&msg=" + e.getMessage());

        } finally {

            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (Exception e) {
                }
            }
        }
    }
}
