import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/verifyotp")
public class VerifyOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String entered = req.getParameter("otp");

        HttpSession session = req.getSession();
        Integer realOtp = (Integer) session.getAttribute("otp");

        if(realOtp != null && entered.equals(realOtp.toString())){
            res.sendRedirect("resetpassword.jsp");
        } else {
            PrintWriter out = res.getWriter();
            out.println("<script>");
            out.println("alert('Wrong OTP');");
            out.println("window.location='otp.jsp';");
            out.println("</script>");
        }
    }
}