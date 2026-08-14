import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import utils.DBConnection;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private String generateStudentCode() {
        return "STU" + (100000 + (int)(Math.random() * 900000));
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("[6-9][0-9]{9}");
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String name = req.getParameter("name");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");
        String primaryPhone = req.getParameter("phone");
        String email = req.getParameter("email");

        PrintWriter out = res.getWriter();

        if(!password.equals(confirm)){
            out.println("<script>");
            out.println("alert('Password mismatch');");
            out.println("window.location='register.jsp';");
            out.println("</script>");
            return;
        }

        List<String> phones = new ArrayList<>();
        if(primaryPhone != null && !primaryPhone.trim().isEmpty()){
            phones.add(primaryPhone.trim());
        }
        String[] altPhones = req.getParameterValues("altphone");
        if(altPhones != null){
            for(String p : altPhones){
                if(p != null && !p.trim().isEmpty() && !phones.contains(p.trim())){
                    phones.add(p.trim());
                }
            }
        }

        if(phones.isEmpty()){
            out.println("<script>");
            out.println("alert('At least one phone number is required');");
            out.println("window.location='register.jsp';");
            out.println("</script>");
            return;
        }

        for(String p : phones){
            if(!isValidPhone(p)){
                out.println("<script>");
                out.println("alert('Invalid phone number: " + p + "');");
                out.println("window.location='register.jsp';");
                out.println("</script>");
                return;
            }
        }

        Connection con = null;
        PreparedStatement ps = null;

        try{
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            PreparedStatement checkUser = con.prepareStatement(
                "SELECT * FROM students WHERE username=?"
            );
            checkUser.setString(1, username);
            ResultSet rs1 = checkUser.executeQuery();

            if(rs1.next()){
                out.println("<script>");
                out.println("alert('Username already exists');");
                out.println("window.location='register.jsp';");
                out.println("</script>");
                return;
            }

            PreparedStatement checkPhoneInStudents = con.prepareStatement(
                "SELECT * FROM students WHERE phone=?"
            );
            PreparedStatement checkPhoneInExtras = con.prepareStatement(
                "SELECT * FROM student_phones WHERE phone=?"
            );

            for(String p : phones){
                checkPhoneInStudents.setString(1, p);
                ResultSet rsS = checkPhoneInStudents.executeQuery();
                checkPhoneInExtras.setString(1, p);
                ResultSet rsE = checkPhoneInExtras.executeQuery();
                if(rsS.next() || rsE.next()){
                    out.println("<script>");
                    out.println("alert('Phone number " + p + " already registered');");
                    out.println("window.location='register.jsp';");
                    out.println("</script>");
                    return;
                }
            }

            PreparedStatement checkEmail = con.prepareStatement(
                "SELECT * FROM students WHERE email=?"
            );
            checkEmail.setString(1, email);
            ResultSet rs3 = checkEmail.executeQuery();

            if(rs3.next()){
                out.println("<script>");
                out.println("alert('Email already registered');");
                out.println("window.location='register.jsp';");
                out.println("</script>");
                return;
            }

            String studentCode;
            PreparedStatement checkCode;
            ResultSet rs4;

            do{
                studentCode = generateStudentCode();
                checkCode = con.prepareStatement(
                    "SELECT * FROM students WHERE student_code=?"
                );
                checkCode.setString(1, studentCode);
                rs4 = checkCode.executeQuery();
            } while(rs4.next());

            ps = con.prepareStatement(
                "INSERT INTO students(fullname,username,password,phone,email,student_code) VALUES(?,?,?,?,?,?)"
            );

            ps.setString(1, name);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, phones.get(0));
            ps.setString(5, email);
            ps.setString(6, studentCode);

            int rows = ps.executeUpdate();

            if(rows > 0){
                PreparedStatement phonePs = con.prepareStatement(
                    "INSERT INTO student_phones(student_code,phone) VALUES(?,?)"
                );
                for(String p : phones){
                    phonePs.setString(1, studentCode);
                    phonePs.setString(2, p);
                    phonePs.executeUpdate();
                }
                con.commit();

                out.println("<script>");
                out.println("alert('Registration Successful! Student Code: " + studentCode + "');");
                out.println("window.location='login.jsp';");
                out.println("</script>");
            }else{
                con.rollback();
                out.println("<script>");
                out.println("alert('Registration Failed');");
                out.println("window.location='register.jsp';");
                out.println("</script>");
            }

        }catch(Exception e){
            e.printStackTrace();
            if(con != null){
                try{ con.rollback(); }catch(Exception r){}
            }
            out.println("<script>");
            out.println("alert('Database Error');");
            out.println("window.location='register.jsp';");
            out.println("</script>");
        }finally{
            try{
                if(ps != null) ps.close();
                if(con != null){
                    con.setAutoCommit(true);
                    con.close();
                }
            }catch(Exception e){}
        }
    }
}
