import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/sendotp")
public class SendOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String username = req.getParameter("username");
        String phone = req.getParameter("phone");

        PrintWriter out = res.getWriter();

        try{
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE username=? AND phone=?"
            );

            ps.setString(1, username);
            ps.setString(2, phone);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){

                int otp = 100000 + (int)(Math.random()*900000);

                HttpSession session = req.getSession();
                session.setAttribute("otp", otp);
                session.setAttribute("resetUser", username);

                out.println("<script>");
                out.println("alert('OTP sent: " + otp + "');");
                out.println("window.location='otp.jsp';");
                out.println("</script>");

            } else {

                out.println("<html>");
                out.println("<head><title>User Not Found</title>");
                out.println("<style>");
                out.println("body{margin:0;height:100vh;display:flex;justify-content:center;align-items:center;font-family:Arial;background:linear-gradient(135deg,#4facfe,#c471ed,#74ebd5);background-size:300% 300%;animation:bg 8s infinite alternate;}");
                out.println("@keyframes bg{from{background-position:left;}to{background-position:right;}}");
                out.println(".card{background:white;padding:40px;border-radius:25px;box-shadow:0 0 25px rgba(255,0,0,0.5),0 0 50px rgba(255,0,0,0.3);text-align:center;width:420px;animation:pop 0.6s ease;}");
                out.println("@keyframes pop{from{transform:scale(0.8);opacity:0;}to{transform:scale(1);opacity:1;}}");
                out.println("h1{color:red;text-shadow:0 0 10px red;}");
                out.println("a{display:inline-block;margin-top:20px;padding:14px 25px;background:#2196F3;color:white;text-decoration:none;border-radius:12px;font-weight:bold;}");
                out.println("a:hover{box-shadow:0 0 15px #2196F3;}");
                out.println("</style></head><body>");

                out.println("<div class='card'>");
                out.println("<h1>User Not Found</h1>");
                out.println("<p style='color:red;font-size:18px;'>Invalid Username or Phone Number</p>");
                out.println("<a href='forgotpassword.jsp'>Back</a>");
                out.println("</div>");

                out.println("</body></html>");
            }

            con.close();

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}