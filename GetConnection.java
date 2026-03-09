package connection;

import java.sql.Connection;
import java.sql.DriverManager;

public class GetConnection {
	public static Connection getCon() {
		Connection con = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_1", "root", "");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return con;
	}
}
