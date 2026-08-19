<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
request.setCharacterEncoding("euc-kr");

String diaryId = request.getParameter("diary_id");
String title = "";
String content = "";
String regDate = "";
String imageName = "";
String categoryName = "";

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr", "multi", "abcd");

    ps = conn.prepareStatement(
      "SELECT d.diary_id, d.title, d.content, d.reg_date, d.image_name, c.category_name " +
      "FROM diary d " +
      "JOIN diary_category c ON d.category_id = c.category_id " +
      "WHERE d.diary_id = ?"
    );

    ps.setString(1, diaryId);
    rs = ps.executeQuery();
    if (rs.next()) {
        diaryId = rs.getString("diary_id");
        title = rs.getString("title");
        content = rs.getString("content");
        regDate = new SimpleDateFormat("yyyy.MM.dd").format(rs.getTimestamp("reg_date"));
        imageName = rs.getString("image_name");
        categoryName = rs.getString("category_name");
    }

    rs.close(); ps.close(); conn.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>

<style>
.detail-wrapper {
	width: 100%;
	max-width: 1600px;
	background-color: #f1f6ed;
	border-radius: 50px;
	padding: 40px;
	box-sizing: border-box;
	margin: 50px auto 0 auto;
	position: relative;
	min-height: 1300px;
}
/* 실제 내용 박스 */
.detail-box {
	width: 100%;
    background: #fff;
    border-radius: 15px;
    margin: 0 auto;
    margin-top: 30px;
    padding: 30px 70px 70px 70px;
    min-height: 1150px;
	max-width: 1450px;
}
.detail-title {
    font-size: 42px;
    font-family: 'GmarketSansTTFMedium';
    margin-bottom: 53px;
    margin-top: 68px;
    text-align: left;
}
.detail-category {
    color: #aaa;
    font-size: 34px;
    margin-bottom: 16px;
	font-family: 'GmarketSansTTFLight';
}

.detail-date {
    color: #888;
    font-size: 34px;
    margin-bottom: 12px;
	font-family: 'GmarketSansTTFLight';
}
.detail-divider {
    border: none;
    border-top: 2px solid #e6e6e6;
    margin: 15px 0 100px 0;
}
.detail-content {
    text-align: center;
    font-size: 34px;
    margin-top: 18px;
    margin-bottom: 16px;
	font-family: 'GmarketSansTTFLight';
}

/*수정 & 삭제 버튼*/
.detail-buttons {
    display: flex;
    justify-content: flex-end;
    gap: 30px;
    margin-top: 36px;
	margin-bottom: 205px;
}

.detail-buttons button {
    padding: 10px 24px;
    font-size: 40px;
    border-radius: 43px;
    border: none;
    cursor: pointer;
    font-family: 'GmarketSansTTFBold';
    transition: 0.2s ease;
}

.detail-buttons .edit-btn {
    background-color: #60af46;
    color: white;
	width: 243px;
	height: 99px;
}

.detail-buttons .delete-btn {
    background-color: #60af46;
    color: white;
	width: 243px;
	height: 99px;
}

.detail-buttons button:hover {
    opacity: 0.9;
}
</style>

<div class="detail-wrapper">
  <div class="detail-box">
    <div class="detail-category"><%= categoryName %></div>
    <div class="detail-title"><%= title %></div>
    <div class="detail-date"><%= regDate %></div>
    <hr class="detail-divider">
    <div class="detail-content"><%= content %></div>
  </div>
</div>

<div class="detail-buttons">
  <button class="delete-btn" id="delete-btn" data-id="<%= diaryId %>">삭제</button>
  <button class="edit-btn" onclick="editDiary('<%= diaryId %>')">수정</button>
</div>

<script>
(function() {
  const deleteBtn = document.getElementById("delete-btn");
  if (deleteBtn) {
    deleteBtn.addEventListener("click", function () {
      const id = this.dataset.id;
      if (!confirm("정말 삭제하시겠습니까?")) return;

      const xhr = new XMLHttpRequest();
      xhr.open("POST", "diary_delete.jsp", true);
      xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
      xhr.overrideMimeType("text/plain; charset=EUC-KR");

      xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
          const res = xhr.responseText.trim();
          if (res === "SUCCESS") {
            alert("삭제되었습니다.");
            if (window.loadSection) {
              loadSection("pencil", 1); 
            } else {
              location.href = "sub4.jsp?section=pencil&page=1";
            }
          } else {
            alert("삭제 실패: " + res);
          }
        }
      };
      xhr.send("diary_id=" + encodeURIComponent(id));
    });
  }
})();

//  반드시 전역 등록 (window)
window.editDiary = function(diaryId) {
  const xhr = new XMLHttpRequest();
  xhr.open("GET", "diary_write.jsp?mode=edit&diary_id=" + encodeURIComponent(diaryId), true);
  xhr.overrideMimeType("text/html; charset=EUC-KR");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      const target = document.getElementById("diary-content");
      if (target) {
        target.innerHTML = xhr.responseText;
      } else {
        alert("diary-content 영역이 없습니다.");
      }
    }
  };
  xhr.send();
};
</script>
