<%@ page import="java.sql.*, java.util.*" %>
<%
  Class.forName("org.gjt.mm.mysql.Driver");
  Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");
  PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM succu_detail ORDER BY product_id");
  ResultSet rs = pstmt.executeQuery();

  List<Map<String, String>> recommendList = new ArrayList<>();
  while (rs.next()) {
    Map<String, String> plant = new HashMap<>();
    plant.put("product_id", rs.getString("product_id"));
    plant.put("name", rs.getString("name"));
    plant.put("description", rs.getString("description"));
    plant.put("water", rs.getString("water"));
    plant.put("water_detail", rs.getString("water_detail"));
    plant.put("temperature", rs.getString("temperature"));
    plant.put("temperature_detail", rs.getString("temperature_detail"));
    plant.put("sun", rs.getString("sun"));
    plant.put("sun_detail", rs.getString("sun_detail"));
    plant.put("humidity", rs.getString("humidity"));
    plant.put("humidity_detail", rs.getString("humidity_detail"));
    recommendList.add(plant);
  }

  rs.close();
  pstmt.close();
  conn.close();
%>
<html>
<head>
<style>
body {
  width: 1920px;
  max-width: 100%;
  overflow-x: hidden;
}

.pm-slide-wrapper {
  background-image: url('images/rmbackground.png');
  background-size: cover;
  background-repeat: no-repeat;
  width: 1920px;
  height: 904px;
  margin-left: -80px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.pm-slide-container {
  position: relative;
  width: 1600px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.pm-slide-viewport {
  width: 100%;
  overflow: hidden;
}

.pm-slide-track {
  display: flex;
  transition: transform 0.5s ease-in-out;
  width: 300%;
}

.pm-slide {
  flex-shrink: 0;
  width: 100%;
  display: flex;
  justify-content: center;
  gap: 100px;
  padding: 40px 0;
}

.pm-arrow {
  width: 100px;
  height: 73px;
  cursor: pointer;
  background: none;
  border: none;
  padding: 0;
  z-index: 10;
}

.pm-left-section {
  text-align: center;
  width: 400px;
}

.pm-plant-img {
  width: 400px;
  height: 400px;
  object-fit: cover;
  margin-bottom: 20px;
}

.pm-plant-name {
  font-size: 35px;
  font-weight: bold;
  color: #4CAF50;
  margin-bottom: 10px;
}

.pm-plant-link {
  font-size: 14px;
  color: #555;
  margin-top: 8px;
}

.pm-center-section {
  max-width: 700px;
}

.pm-plant-desc {
  font-size: 24px;
  text-align: center;
  margin-bottom: 40px;
  color: #333;
  line-height: 1.7;
}

.pm-info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  border-top: 2px solid #4CAF50;
  border-bottom: 2px solid #4CAF50;
  padding: 40px 0;
  gap: 32px;
}

.pm-info-box {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.pm-info-icon {
  width: 30px;
  height: 30px;
  margin-bottom: 8px;
}

.pm-info-title {
  font-weight: bold;
  font-size: 16px;
  color: #222;
  margin-bottom: 4px;
}

.pm-info-sub {
  font-size: 14px;
  color: #666;
  line-height: 1.5;
}
</style>
</head>
<body>
<!--  1. HTML 구조 -->
<div class="pm-slide-wrapper">
  <div class="pm-slide-container">
    <button type="button" class="pm-arrow pm-prev">
      <img src="images/left_arrow.png" alt="이전">
    </button>

    <div class="pm-slide-viewport">
      <div class="pm-slide-track">
        <% for (Map<String, String> plant : recommendList) { %>
        <div class="pm-slide">
          <div class="pm-left-section">
            <img src="images/<%=plant.get("product_id")%>.png" alt="<%=plant.get("name")%>" class="pm-plant-img">
            <div class="pm-plant-name"><%=plant.get("name")%></div>
            <div class="pm-plant-link">알아보기 &gt;</div>
          </div>

          <div class="pm-center-section">
            <div class="pm-plant-desc"><%=plant.get("description")%></div>
            <div class="pm-info-grid">
              <div class="pm-info-box">
                <img src="images/g_water.png" class="pm-info-icon" alt="물">
                <div class="pm-info-title"><%=plant.get("water")%></div>
                <div class="pm-info-sub"><%=plant.get("water_detail")%></div>
              </div>
              <div class="pm-info-box">
                <img src="images/g_thermometer.png" class="pm-info-icon" alt="온도">
                <div class="pm-info-title"><%=plant.get("temperature")%></div>
                <div class="pm-info-sub"><%=plant.get("temperature_detail")%></div>
              </div>
              <div class="pm-info-box">
                <img src="images/g_sun.png" class="pm-info-icon" alt="햇빛">
                <div class="pm-info-title"><%=plant.get("sun")%></div>
                <div class="pm-info-sub"><%=plant.get("sun_detail")%></div>
              </div>
              <div class="pm-info-box">
                <img src="images/g_cloud.png" class="pm-info-icon" alt="습도">
                <div class="pm-info-title"><%=plant.get("humidity")%></div>
                <div class="pm-info-sub"><%=plant.get("humidity_detail")%></div>
              </div>
            </div>
          </div>
        </div>
        <% } %>
      </div>
    </div>

    <button type="button" class="pm-arrow pm-next">
      <img src="images/right_arrow.png" alt="다음">
    </button>
  </div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function () {
  const slides = document.querySelectorAll('.pm-slide');
  const slideTrack = document.querySelector('.pm-slide-track');
  const prevBtn = document.querySelector('.pm-prev');
  const nextBtn = document.querySelector('.pm-next');
  let currentIndex = 0;

  function showSlide(index) {
    const offset = -index * 100;
    slideTrack.style.transform = `translateX(${offset}%)`;
  }

  if (slides.length && slideTrack && prevBtn && nextBtn) {
    prevBtn.addEventListener('click', () => {
      currentIndex = (currentIndex - 1 + slides.length) % slides.length;
      showSlide(currentIndex);
    });

    nextBtn.addEventListener('click', () => {
      currentIndex = (currentIndex + 1) % slides.length;
      showSlide(currentIndex);
    });

    showSlide(0);
  } else {
    console.warn("슬라이드 요소를 찾을 수 없습니다.");
  }
});
</script>
</body>


</html>

