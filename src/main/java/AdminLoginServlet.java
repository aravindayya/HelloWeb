import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/adminlogin")
public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if(username.equals("admin") && password.equals("1234")) {

            HttpSession session = req.getSession();

            session.setAttribute("admin", "yes");

            res.sendRedirect("index.jsp");

        } else {
            PrintWriter out = res.getWriter();
            out.println("<script>");
            out.println("alert('Wrong Admin Login');");
            out.println("window.location='adminlogin.jsp';");
            out.println("</script>");
        }
    }
}