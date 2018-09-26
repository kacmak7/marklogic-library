import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class Main {
    public static void main(String args[]) {
        String path = "C:\\Users\\Kacper Makuch\\Documents\\library\\book.xml";
        File file = new File(path);
        StringBuilder builder = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while((line = br.readLine()) != null) {
                builder.append(line).append("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        //return builder.toString();
        //return i <= 1 ? builder.toString() : null;
        System.out.println(builder.toString());
        System.out.println(file.getName());
    }

}
