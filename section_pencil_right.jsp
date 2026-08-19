<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page isELIgnored="true" %>
<%! 
public String stripHtml(String html) {
    return html == null ? "" : html.replaceAll("<[^>]*>", "");
}
%>
<%
request.setCharacterEncoding("euc-kr");
String sid = (String) session.getAttribute("sid");
String selectedCatId = request.getParameter("category_id");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
java.util.List<String[]> postList = new java.util.ArrayList<>();
try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr", "multi", "abcd");

    String sql;
    if (selectedCatId != null && !selectedCatId.trim().equals("")) {
        sql = "SELECT d.diary_id, d.title, d.content, d.reg_date, d.image_name, d.category_id " +
                "FROM diary d JOIN diary_category c ON d.category_id = c.category_id " +
                "WHERE c.user_id = ? AND d.category_id = ? " +
                "ORDER BY d.diary_id DESC";
        ps = conn.prepareStatement(sql);
        ps.setString(1, sid);
        ps.setString(2, selectedCatId);
    } else {
        sql = "SELECT d.diary_id, d.title, d.content, d.reg_date, d.image_name, d.category_id " +
                "FROM diary d JOIN diary_category c ON d.category_id = c.category_id " +
                "WHERE c.user_id = ? " +
                "ORDER BY d.diary_id DESC";
        ps = conn.prepareStatement(sql);
        ps.setString(1, sid);
    }
    rs = ps.executeQuery();
    while (rs.next()) {
        String diaryId = rs.getString("diary_id");
        String title = rs.getString("title");
        String content = rs.getString("content");
        String date = new java.text.SimpleDateFormat("yyyy.MM.dd").format(rs.getTimestamp("reg_date"));
        String imageName = rs.getString("image_name");
        if (imageName != null && imageName.startsWith("/uploads/")) {
            imageName = imageName.substring("/uploads/".length());
        }
        String postCatId = rs.getString("category_id");
        //  diaryId도 포함시켜야 index가 안 밀림
        postList.add(new String[]{diaryId, title, content, date, imageName, postCatId});
    }
    rs.close(); ps.close(); conn.close();
} catch(Exception e) { }
%>

<div class="growth-title">성장일지</div>
<% boolean hasPost = false;
   for (String[] post : postList) {
     String diaryId = post[0];
     String title = post[1];
     String content = post[2];
     String regDate = post[3];
     String imageName = post[4];
     String textOnly = stripHtml(content);
     hasPost = true;
%>
   <div class="pencil-post-box" onclick="loadDiaryDetail('<%= diaryId %>')">
    <div class="pencil-thumbnail"
      <% if (imageName != null && !imageName.trim().equals("")) { %>
        style="background-image:url('/uploads/<%= imageName %>');background-size:cover;background-position:center;"
      <% } %>
    ></div>
    <div class="pencil-post-content">
      <div class="pencil-post-title"><%= title %></div>
      <div class="pencil-post-text">
        <%= textOnly.length() > 60 ? textOnly.substring(0, 60) + "..." : textOnly %>
      </div>
      <div class="pencil-post-date"><%= regDate %></div>
    </div>
  </div>
<% }
  if (!hasPost) { %>
    <div class="no-post">해당 카테고리의 일기가 없습니다.</div>
<% } %>

<script>
function loadDiaryDetail(diaryId) {
  const xhr = new XMLHttpRequest();
  xhr.open("GET", "diary_detail.jsp?diary_id=" + encodeURIComponent(diaryId), true);
  xhr.overrideMimeType("text/html;charset=EUC-KR");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      const wrapper = document.querySelector(".growth-wrapper");
      if (wrapper) {
        wrapper.outerHTML = xhr.responseText;

        //  스크립트 수동 실행
        const tempDiv = document.createElement("div");
        tempDiv.innerHTML = xhr.responseText;
        const scripts = tempDiv.querySelectorAll("script");

        scripts.forEach(script => {
          try {
            eval(script.innerText);
          } catch (e) {
            console.error("스크립트 실행 오류:", e);
          }
        });
      }
    }
  };

  xhr.send();
}

</script>
