import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import utils.DBConnection;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private String generateStudentCode() {
        return "STU" + (100000 + (int)(Math.random() * 900000));
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String name = req.getParameter("name");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        PrintWriter out = res.getWriter();

        if(!password.equals(confirm)){
            out.println("<script>");
            out.println("alert('Password mismatch');");
            out.println("window.location='register.jsp';");
            out.println("</script>");
            return;
        }

        try{
            Connection con = DBConnection.getConnection();

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

            PreparedStatement checkPhone = con.prepareStatement(
                "SELECT * FROM students WHERE phone=?"
            );
            checkPhone.setString(1, phone);
            ResultSet rs2 = checkPhone.executeQuery();

            if(rs2.next()){
                out.println("<script>");
                out.println("alert('Phone number already registered');");
                out.println("window.location='register.jsp';");
                out.println("</script>");
                return;
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

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO students(fullname,username,password,phone,email,student_code) VALUES(?,?,?,?,?,?)"
            );

            ps.setString(1, name);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, email);
            ps.setString(6, studentCode);

            int rows = ps.executeUpdate();

            if(rows > 0){
                out.println("<script>");
                out.println("alert('Registration Successful! Student Code: " + studentCode + "');");
                out.println("window.location='login.jsp';");
                out.println("</script>");
            }else{
                out.println("<script>");
                out.println("alert('Registration Failed');");
                out.println("window.location='register.jsp';");
                out.println("</script>");
            }

            con.close();

        }catch(Exception e){
            e.printStackTrace();

            out.println("<script>");
            out.println("alert('Database Error');");
            out.println("window.location='register.jsp';");
            out.println("</script>");
        }
    }
}