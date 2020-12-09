import java.nio.charset.StandardCharsets;

public class Main {
    public static void main(String[] args) throws Exception {
        byte[] bytes = "百度".getBytes("GBK");
        for (byte b : bytes) {
            System.out.println(Integer.toHexString(b & 0xFF));
        }
    }
}
