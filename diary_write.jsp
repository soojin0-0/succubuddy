<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*" %>

<%
request.setCharacterEncoding("euc-kr");

String sid = (String) session.getAttribute("sid");
if (sid == null || sid.trim().equals("")) {
  response.sendRedirect("login.jsp");
  return;
}

String mode = request.getParameter("mode");
String diaryId = request.getParameter("diary_id");

String title = "";
String content = "";
String selectedCategoryId = "";
String imageName = "";

java.util.List<String[]> categories = new java.util.ArrayList<>();

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
  Class.forName("org.gjt.mm.mysql.Driver");
  conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr", "multi", "abcd");

  //  카테고리 먼저 로딩
  ps = conn.prepareStatement("SELECT category_id, category_name FROM diary_category WHERE user_id = ?");
  ps.setString(1, sid);
  rs = ps.executeQuery();
  while (rs.next()) {
    categories.add(new String[]{ rs.getString("category_id"), rs.getString("category_name") });
  }
  rs.close(); ps.close();

  //  수정모드일 경우 해당 글 내용 조회
  if ("edit".equals(mode) && diaryId != null) {
    ps = conn.prepareStatement("SELECT title, content, category_id, image_name FROM diary WHERE diary_id = ?");
    ps.setString(1, diaryId);
    rs = ps.executeQuery();
    if (rs.next()) {
        title = rs.getString("title");
        content = rs.getString("content");
        selectedCategoryId = rs.getString("category_id");
        imageName = rs.getString("image_name"); // 추가
    }
  }

} catch (Exception e) {
  out.println("<script>alert('데이터 불러오기 오류');</script>");
} finally {
  if (rs != null) try { rs.close(); } catch (Exception e) {}
  if (ps != null) try { ps.close(); } catch (Exception e) {}
  if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>

<style>
   * {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  width: 1920px;
  max-width: 100%;
  overflow-x: hidden;
}

html, body {
  width: 100%;
  margin: 0;
  padding: 0;
  background-color: #ffffff;
  overflow-x: hidden;
  overflow-y: auto;
}

.editor-container {
  width: 100%;
  max-width: 1600px;
  background-color: #f1f6ed;
  border-radius: 20px;
  padding: 40px;
  box-sizing: border-box;
  font-family: 'GmarketSansTTFMedium';
  margin: 50px auto 0 auto;
  position: relative;
  min-height: 1300px;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #ffffff;
  height: 150px;
  width: 100%;
  max-width: 1517px;
  border-radius: 15px;
  font-size: 17px;
  padding: 0 30px;
  margin: 0 auto 30px;
  box-sizing: border-box;
}

.toolbar-left {
  display: flex;
  align-items: center;
  gap: 50px;
}

.toolbar-left > *:not(:last-child) {
  border-right: 1px solid #ccc;
  padding-right: 30px;
  margin-right: 0;
}

.toolbar-left .icon-photo {
  width: 55px;
  height: 55px;
}

.toolbar-left .photo-label {
  font-size: 26px;
  color: #444;
  margin-top: 6px;
  display: block;
  text-align: center;
}

.toolbar-left select[name="fontSize"] {
  font-size: 30px;
  border: none;
  appearance: none;
  background: transparent;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='30' height='16' viewBox='0 0 10 6'%3E%3Cpath fill='%23333' d='M0 0l5 6 5-6z'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right center;
  padding-right: 42px;
  font-family: 'GmarketSansTTFLight';
}
#bold-btn {
  font-size: 38px;  /* 기존에 사용 중인 크기 유지 */
  font-family: 'GmarketSansTTFBold'; /* 기존 폰트 사용 */
  background: transparent;
  border: none;
  color: #444;
  cursor: pointer;
  padding: 0;
  margin: 0;
  text-align: center;
  width: 40px;  /* 버튼 크기 조정 */
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
}

#bold-btn:focus {
  outline: none;  /* 포커스 시 테두리 제거 */
}

.toolbar-right {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 15px;
  width: 354px;
  height: 143px;
}

.toolbar-right .vertical-divider {
  height: 35px;
  width: 1px;
  background-color: #ccc;
}

.toolbar-right .category-select {
  font-size: 28px;
  font-family: 'GmarketSansTTFMedium';
  border: none;
  outline: none;
  box-shadow: none;
  background: transparent;
  appearance: none;
  background-image: url("/succu/images/arrow-big.png");
  background-repeat: no-repeat;
  background-position: center right;
  background-size: 30px;
  padding-right: 35px;
  text-align: center;
  width: 200px;
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.editor-box {
  background-color: #ffffff;
  border: none !important;
  box-shadow: none !important;
  padding: 40px;
  width: 100%;
  max-width: 1517px;
  margin: 0 auto;
  box-sizing: border-box;
  min-height: 900px;
  margin-top: 10px;
}

.editor-box input.title {
  font-size: 38px;
  width: 100%;
  border: none;
  font-family: 'GmarketSansTTFMedium';
  padding: 30px;
  margin-bottom: 10px;
  text-align: center;
  box-sizing: border-box;
}

.editor-box .custom-hr {
  width: 1280px;
  margin: 0 auto 20px auto;
  border-bottom: 1px solid #ccc;
}

input.title::placeholder {
  font-size: 35px;
  color: #aaa;
  font-family: 'GmarketSansTTFMedium';
  border-radius: 15px;
}

textarea.content::placeholder {
  font-size: 30px;
  color: #aaa;
  font-family: 'GmarketSansTTFLight';
}

.editor-buttons-wrapper {
  width: 100%;
  max-width: 1600px;
  text-align: right;
  box-sizing: border-box;
  margin: 30px auto 50px auto;
  padding-right: 40px;
}

.editor-buttons-wrapper button {
  width: 243px;
  height: 93px;
  background-color: #4caf50;
  color: white;
  border: none;
  font-size: 38px;
  border-radius: 30px;
  font-family: 'GmarketSansTTFBold';
  cursor: pointer;
  margin-left: 10px;
}

/*  이미지 업로드 버튼 */
.image-upload-label {
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
  
}

/*  삽입된 이미지 및 텍스트 캡션 */
.inserted-image {
  max-width: 300px;
  max-height: 300px;
  display: block;
  margin: 0 auto;
}


.image-label {
  font-size: 22px;
  color: #222;
  font-family: 'GmarketSansTTFMedium';
  text-align: center;
  margin: 0;
  min-width: 180px;
}

/*  본문 내용 영역 */
#contentEditable {
    min-height: 300px;
    border: none !important;
    outline: none !important;
    box-shadow: none !important;
    padding: 10px;
    font-size: 24px;
    line-height: 1.5;
	text-align: center;
	font-family: 'GmarketSansTTFLight';
	border-radius: 15px;
	white-space: pre-wrap; /* 줄바꿈 및 공백 유지 */
}

  #contentEditable img {
    max-width: 300px;
    display: block;
    margin: 10px auto;
	border: none !important;
  }

/*  정렬 아이콘 셀렉트 */
/* 기본적으로 아이콘을 숨기기 */
  #left-align, #middle-align, #right-align {
    display: none;
  }

  /* 각 아이콘을 클릭하면 해당 아이콘만 보이도록 */
  #left-align, #middle-align, #right-align {
    display: inline-block;
    cursor: pointer;
  }

  /* 이미지는 클릭할 수 있도록 크기 조정 */
  #left-align img, #middle-align img, #right-align img {
    width: 40px;
    height: 40px;
  }

  /* 기본적으로 가운데 정렬 */
  #editor {
    text-align: center;
  }
</style>

<form id="diaryForm" method="post" action="diary_write_action.jsp" accept-charset="euc-kr" enctype="multipart/form-data">
  <div class="editor-container">
    <div class="toolbar">
      <div class="toolbar-left">
         <label class="image-upload-label">
          <img src="images/Attach.png" alt="사진 아이콘" class="icon-photo">
          <span class="photo-label">사진</span>
          <!--  js 예제랑 id 맞춤 -->
          <input type="file" id="imageInput"  multiple accept="image/*" style="display:none"/>
        </label>
		 <!--  폰트 사이즈 선택 -->
        <select type="text" id="fontSizeSelect" name="fontSize" class="font-size-select">
		  <option value="11px">11</option>
		  <option value="12px">12</option>
		  <option value="13px">13</option>
		  <option value="14px">14</option>
		  <option value="15px">15</option>
		  <option value="16px">16</option>
		  <option value="18px">18</option>
		  <option value="20px">20</option>
		  <option value="22px">22</option>
		  <option value="24px" selected>24</option>
		  <option value="26px">26</option>
		  <option value="28px">28</option>
		  <option value="30px">30</option>
		  <option value="32px">32</option>
		  <option value="34px">34</option>
		  <option value="36px">36</option>
		  <option value="38px">38</option>
		  <option value="40px">40</option>
		  <option value="42px">42</option>
		  <option value="44px">44</option>
		  <option value="46px">46</option>
		  <option value="48px">48</option>
		  <option value="50px">50</option>
		  <option value="52px">52</option>
		  <option value="54px">54</option>
		  <option value="56px">56</option>
		  <option value="58px">58</option>
		  <option value="60px">60</option>
		</select>


        <button type="button" id="bold-btn"><b>B</b></button>
      <!-- 정렬 버튼 (이미지 클릭) -->
        <div id="align-btn">
          <label for="left" id="left-align">
            <img src="images/left.png" alt="Left Align" />
          </label>

          <label for="middle" id="middle-align">
            <img src="images/middle.png" alt="Center Align" />
          </label>

          <label for="right" id="right-align">
            <img src="images/right.png" alt="Right Align" />
          </label>
        </div>



      </div>
      <div class="toolbar-right">
        <div class="vertical-divider"></div>
        <select name="category_id" class="category-select" required>
          <option value="">카테고리 선택</option>
          <% for (String[] c : categories) { %>
          <option value="<%= c[0] %>" <%= c[0].equals(selectedCategoryId) ? "selected" : "" %>><%= c[1] %></option>
          <% } %>
        </select>
      </div>
    </div>

    <div class="editor-box">
	  <!-- 제목 입력란: 수정모드일 경우 기존 제목 표시 -->
	  <input type="text" class="title" name="title" placeholder="제목" required value="<%= title %>">

	  <div class="custom-hr"></div>
	  <!-- 본문 입력 영역: 수정모드일 경우 기존 내용 삽입 -->
	  <div contenteditable="true" id="contentEditable" data-placeholder="내용을 입력하세요."><%= content %></div>
	  <% if ("edit".equals(mode)) { %>
		<div id="initialContent" style="display:none;"><%= content %></div>
	  <% } %>

	  <input type="hidden" name="used_images" id="usedImages">
	  <input type="hidden" name="content" id="hiddenContent">
	  <% if ("edit".equals(mode)) { %>
	    <input type="hidden" name="mode" value="edit">
	    <input type="hidden" name="diary_id" value="<%= diaryId %>">
		<input type="hidden" name="existing_image" value="<%= imageName %>">
	  <% } %>

	</div>
  </div>

  <div class="editor-buttons-wrapper">
    <button type="button" onclick="location.href='sub4.jsp?section=pencil&page=1'">등록 취소</button>


    <button type="submit" id="submitBtn">등록</button>
  </div>
</form>

<!-- ...폼 및 html 코드... -->
<script>

window.addEventListener('DOMContentLoaded', function () {
  const editor = document.getElementById('contentEditable');
  const fontSizeSelect = document.getElementById('fontSizeSelect');
  const imageInput = document.getElementById('imageInput');
  const boldBtn = document.getElementById("bold-btn");
  const leftAlign = document.getElementById('left-align');
  const middleAlign = document.getElementById('middle-align');
  const rightAlign = document.getElementById('right-align');
  const submitBtn = document.getElementById('submitBtn'); // 등록 버튼
  
  //  [여기에 추가] - 수정모드에서 기존 내용 삽입
const initialContent = document.getElementById('initialContent')?.innerHTML;
if (initialContent && editor) {
  editor.innerHTML = initialContent;
}






  // 필요한 요소가 없는 경우 콘솔 에러
 if (!editor || !fontSizeSelect || !boldBtn || !submitBtn || !leftAlign || !middleAlign || !rightAlign) {
    console.error('필요한 요소가 없습니다.');
    return;
  }

   // 기본적으로 가운데 아이콘만 보이게
    middleAlign.style.display = 'inline-block';
    leftAlign.style.display = 'none';
    rightAlign.style.display = 'none';

  // 폰트 크기 변경
  fontSizeSelect.addEventListener('change', () => {
    editor.style.fontSize = fontSizeSelect.value;
  });

  // 이미지 추가
	  imageInput?.addEventListener('change', () => {
		const files = imageInput.files;
		if (!files.length) return;

		Array.from(files).forEach(file => {
		  const reader = new FileReader();
		  reader.onload = (e) => {
			const img = document.createElement('img');
			img.src = e.target.result; // base64 데이터 (서버로 아직 안감!)
			editor.appendChild(img);
			editor.appendChild(document.createElement('br'));
		  };
		  reader.readAsDataURL(file);
		});
		imageInput.value = '';
	});


  // 볼드체 적용
  boldBtn.addEventListener('click', () => {
    const selection = window.getSelection();
    const range = selection.getRangeAt(0);
    const selectedText = selection.toString();

    if (selectedText) {
      const span = document.createElement('span');
      const currentWeight = window.getComputedStyle(range.startContainer.parentNode).fontWeight;

      // 이미 볼드체면 취소, 아니면 적용
      if (currentWeight === 'bold') {
        span.style.fontWeight = 'normal'; // 취소
      } else {
        span.style.fontWeight = 'bold'; // 볼드체
      }

      range.surroundContents(span);  // 선택한 텍스트를 <span> 태그로 감쌈
    } else {
      document.execCommand('bold');
    }
  });

  // 가운데 정렬 클릭 시
    middleAlign.addEventListener('click', function () {
      middleAlign.style.display = 'inline-block';
      leftAlign.style.display = 'none';
      rightAlign.style.display = 'none';
      editor.style.textAlign = 'center';  // 가운데 정렬
    });

    // 왼쪽 정렬 클릭 시
    leftAlign.addEventListener('click', function () {
      leftAlign.style.display = 'inline-block';
      middleAlign.style.display = 'none';
      rightAlign.style.display = 'none';
      editor.style.textAlign = 'left';  // 왼쪽 정렬
    });

    // 오른쪽 정렬 클릭 시
    rightAlign.addEventListener('click', function () {
      rightAlign.style.display = 'inline-block';
      middleAlign.style.display = 'none';
      leftAlign.style.display = 'none';
      editor.style.textAlign = 'right';  // 오른쪽 정렬
    });
	 // 등록 버튼 클릭 시 폼 제출 및 내용 저장
	submitBtn.addEventListener('click', function () {
	  // contentEditable에서 본문 내용 가져오기
	  const content = document.getElementById('contentEditable').innerHTML;
	  document.getElementById('hiddenContent').value = content;  // content를 hidden input에 저장
	  document.getElementById('diaryForm').submit();  // 폼 제출
	});
	
});

</script>





