package service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class GHNService {

    private static final String GHN_TOKEN;
    private static final String GHN_SHOP_ID;

    static {
        try {
            java.io.InputStream is = GHNService.class.getClassLoader().getResourceAsStream("db.properties");
            java.util.Properties props = new java.util.Properties();
            props.load(is);
            GHN_TOKEN = props.getProperty("ghn.token");
            GHN_SHOP_ID = props.getProperty("ghn.shop_id");
        } catch (Exception e) {
            throw new RuntimeException("Lỗi cấu hình GHN: " + e.getMessage());
        }
    }

    private static final String FEE_API_URL = "https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee";
    private static final String PROVINCE_API_URL = "https://online-gateway.ghn.vn/shiip/public-api/master-data/province";
    private static final String DISTRICT_API_URL = "https://online-gateway.ghn.vn/shiip/public-api/master-data/district";
    private static final String WARD_API_URL = "https://online-gateway.ghn.vn/shiip/public-api/master-data/ward";

    private final HttpClient httpClient;

    public GHNService() {
        this.httpClient = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_2)
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    public int calculateShippingFee(int fromDistrictId, int toDistrictId, String toWardCode, int weight, int insuranceValue)
            throws Exception {
        if ((toWardCode == null || toWardCode.isEmpty()) && toDistrictId > 0) {
            toWardCode = getFirstWardCode(toDistrictId);
        }

        int serviceTypeId = 2;

        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("from_district_id", fromDistrictId);
        requestBody.addProperty("from_ward_code", "21012");
        requestBody.addProperty("to_district_id", toDistrictId);
        if (toWardCode != null && !toWardCode.isEmpty()) {
            requestBody.addProperty("to_ward_code", toWardCode);
        }
        requestBody.addProperty("weight", weight);
        requestBody.addProperty("insurance_value", insuranceValue);
        requestBody.addProperty("service_type_id", serviceTypeId);

        String jsonString = requestBody.toString();
        System.out.println("[GHN] Request body: " + jsonString);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(FEE_API_URL))
                .header("Content-Type", "application/json")
                .header("Token", GHN_TOKEN)
                .POST(HttpRequest.BodyPublishers.ofString(jsonString))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println("[GHN] Response: " + response.body());

        if (response.statusCode() == 200) {
            JsonObject jsonObject = JsonParser.parseString(response.body()).getAsJsonObject();
            int code = jsonObject.get("code").getAsInt();
            if (code == 200) {
                JsonObject data = jsonObject.getAsJsonObject("data");
                return data.get("total").getAsInt();
            } else {
                throw new Exception(jsonObject.get("message").getAsString());
            }
        } else {
            throw new Exception("HTTP " + response.statusCode() + ": " + response.body());
        }
    }

    private String getFirstWardCode(int districtId) {
        try {
            String wardsJson = getWards(districtId);
            JsonObject obj = JsonParser.parseString(wardsJson).getAsJsonObject();
            if (obj.get("code").getAsInt() == 200 && obj.getAsJsonArray("data").size() > 0) {
                return obj.getAsJsonArray("data").get(0).getAsJsonObject().get("WardCode").getAsString();
            }
        } catch (Exception e) {
            System.err.println("[GHN] Failed to get first ward code: " + e.getMessage());
        }
        return null;
    }

    public String getProvinces() throws Exception {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(PROVINCE_API_URL))
                .header("Token", GHN_TOKEN)
                .GET()
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }

    public String getDistricts(int provinceId) throws Exception {
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("province_id", provinceId);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(DISTRICT_API_URL))
                .header("Content-Type", "application/json")
                .header("Token", GHN_TOKEN)
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }

    public String getWards(int districtId) throws Exception {
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("district_id", districtId);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(WARD_API_URL))
                .header("Content-Type", "application/json")
                .header("Token", GHN_TOKEN)
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        return response.body();
    }
}
