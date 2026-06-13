package service;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class GHNService {

    private static final String GHN_TOKEN = "YOUR_GHN_TOKEN_HERE";
    
    private static final String GHN_SHOP_ID = "YOUR_SHOP_ID_HERE";

    private static final String FEE_API_URL = "https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/fee";

    private final HttpClient httpClient;

    public GHNService() {
        this.httpClient = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_2)
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    public int calculateShippingFee(int fromDistrictId, int toDistrictId, int weight, int insuranceValue) throws Exception {
        
        int serviceTypeId = 2;

        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("from_district_id", fromDistrictId);
        requestBody.addProperty("to_district_id", toDistrictId);
        requestBody.addProperty("weight", weight);
        requestBody.addProperty("insurance_value", insuranceValue);
        requestBody.addProperty("service_type_id", serviceTypeId);

        String jsonString = requestBody.toString();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(FEE_API_URL))
                .header("Content-Type", "application/json")
                .header("Token", GHN_TOKEN)
                .header("ShopId", GHN_SHOP_ID)
                .POST(HttpRequest.BodyPublishers.ofString(jsonString))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() == 200) {
            JsonObject jsonObject = JsonParser.parseString(response.body()).getAsJsonObject();
            
            int code = jsonObject.get("code").getAsInt();
            if (code == 200) {
                JsonObject data = jsonObject.getAsJsonObject("data");
                return data.get("total").getAsInt();
            } else {
                String message = jsonObject.get("message").getAsString();
                throw new Exception("Lỗi từ GHN: " + message);
            }
        } else {
            throw new Exception("Call API thất bại, HTTP Status: " + response.statusCode());
        }
    }
}
