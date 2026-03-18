import java.util.ArrayList;

class Reader{
  public ArrayList<Flight> readIn(int start, int end, String filter) {
    String[] data = loadStrings("flights10k.csv");
    ArrayList<Flight> result = new ArrayList<Flight>();
    
    boolean applyFilter = !filter.equalsIgnoreCase("n/a");

    int columnIndex = -1;
    String filterValue = "";
    
    if (applyFilter) {
      String[] parts = filter.split(",");   // 不再强依赖 ", "
      if (parts.length == 2) {
        String category = parts[0].trim().toLowerCase();
        filterValue = parts[1].trim().toLowerCase();

        String[] headers = {
          "flight date", "iata code", "flight number", "origin airport","origin city", "x", "origin state", "origin wac","destination airport", "destination city", "x",
          "destination state", "destination wac","scheduled departure time", "actual departure time","scheduled arrival time", "actual arrival time",
          "cancelled", "diverted", "distance between airports"
        };

        for (int i = 0; i < headers.length; i++) {
          if (headers[i].equals(category)) {
            columnIndex = i;
            break;
          }
        }

        // 如果找不到 → 关闭filter
        if (columnIndex == -1) {
          applyFilter = false;
        }
      } else {
        applyFilter = false;
      }
    }

    // ===== Step 4: 处理 end =====
    if (end == 0 || end > data.length){
      end = data.length;
    }

    // ===== Step 5: 遍历数据 =====
    for (int i = start; i < end; i++){
      String[] row = split(data[i], ',');

      // 防止数据不完整
      if (row.length < 20){
        continue;
      }
        row[4] = cleanText(row[4]);
        row[9] = cleanText(row[9]);

      // ===== Step 6: 判断是否符合filter =====
      boolean match = true;
      
      if (applyFilter) {
        match = row[columnIndex].toLowerCase().equals(filterValue);
      }

      if (!match) {
        continue;
      }
      // ===== Step 7: 解析数据（更安全） =====
      boolean cancelled = row[17].equals("1");
      boolean diverted = row[18].equals("1");

      int distance = safeInt(row[19]);

      // ===== Step 8: 创建对象 =====
      Flight f = new Flight(
        row[0], row[1], row[2],row[3], row[4], row[6],row[7], row[8], row[9],row[11], row[12], row[13],row[14], row[15], row[16],
        diverted, cancelled, distance
      );

      result.add(f);
    }

    return result;
  }


  // ===== 工具函数：清理字符串 =====
  String cleanText(String s) {
    return s.replace("\"", "").trim();
  }


  // ===== 工具函数：安全转int =====
  int safeInt(String s) {
    try {
      return Integer.parseInt(s);
    } catch (Exception e) {
      return 0;
    }
  }
}

Reader reader = new Reader();

void setup() {
  size(800, 600);

  // ===== Test 1：不加filter =====
  ArrayList<Flight> all = reader.readIn(1, 100, "n/a");
  println("All flights: " + all.size());

  // ===== Test 2：filter by airline =====
  ArrayList<Flight> aa = reader.readIn(1, 100, "iata code, AA");
  println("AA flights: " + aa.size());

  // ===== Test 3：filter cancelled =====
  ArrayList<Flight> cancelled = reader.readIn(1, 100, "cancelled, 1");
  println("Cancelled flights: " + cancelled.size());

  // ===== Test 4：filter diverted =====
  ArrayList<Flight> diverted = reader.readIn(1, 100, "diverted, 1");
  println("Diverted flights: " + diverted.size());
}
