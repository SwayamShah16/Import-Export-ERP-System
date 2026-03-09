<%
    // Invalidate current session if exists
    if (session != null) {
        session.invalidate();
    }
    // Redirect to login page
    response.sendRedirect("login.jsp?msg=loggedout");
%>
