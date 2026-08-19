<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<%
    request.setCharacterEncoding("euc-kr");
    String userId = (String) session.getAttribute("sid");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 폼 데이터 수신
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String postcode = request.getParameter("postcode");
    String address1 = request.getParameter("address1");
    String address2 = request.getParameter("address2");
    String call1 = request.getParameter("call1");
    String call2 = request.getParameter("call2");
    String call3 = request.getParameter("call3");
    String cell1 = request.getParameter("cell1");
    String cell2 = request.getParameter("cell2");
    String cell3 = request.getParameter("cell3");
    String email_name = request.getParameter("email_name");
    String domain = request.getParameter("domain");
    String gender = request.getParameter("gender");
    String birthYear = request.getParameter("birthYear");
    String birthMonth = request.getParameter("birthMonth");
    String birthDay = request.getParameter("birthDay");
	String level = request.getParameter("level");

    // 데이터 가공
    String address = postcode + "," + address1 + "," + address2;
    String phone = call1 + "-" + call2 + "-" + call3;
    String mobilePhone = cell1 + "-" + cell2 + "-" + cell3;
    String email = email_name + "@" + domain;
    String birthDate = birthYear + "-" + birthMonth + "-" + birthDay;

    try {
        String DB_URL = "jdbc:mysql://localhost:3306/succu";
        String DB_ID = "multi";
        String DB_PASSWORD = "abcd";

        Class.forName("org.gjt.mm.mysql.Driver");
        Connection con = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        String sql = "UPDATE user SET username = ?, password = ?, address = ?, phone = ?, mobile_phone = ?, email = ?, gender = ?, birth_date = ?, level = ? WHERE user_id = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, password);
        pstmt.setString(3, address);
        pstmt.setString(4, phone);
        pstmt.setString(5, mobilePhone);
        pstmt.setString(6, email);
        pstmt.setString(7, gender);
        pstmt.setString(8, birthDate);
		pstmt.setString(9, level);
        pstmt.setString(10, userId);

        int result = pstmt.executeUpdate();

        pstmt.close();
        con.close();

        if (result > 0) {
%>
            <script>
                alert("[수정이 완료되었습니다]");
                window.location.href = "mypage_info.jsp";
            </script>
<%
        } else {
%>
            <script>
                alert("[수정에 실패했습니다. 다시 시도해주세요]");
                window.history.back();
            </script>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류 발생: " + e.getMessage());
    }
%>
