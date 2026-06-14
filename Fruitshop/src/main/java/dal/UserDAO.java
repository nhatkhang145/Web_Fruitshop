package dal;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import org.jdbi.v3.core.mapper.RowMapper;

import model.Address;
import model.User;

public class UserDAO {
    private final RowMapper<User> userMapper = (rs, ctx) -> {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("fullname"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getInt("role"));
        if (hasRoleIdColumn()) {
            int roleId = rs.getInt("role_id");
            user.setRoleId(rs.wasNull() ? null : roleId);
        }
        user.setAvatar(rs.getString("avatar"));
        user.setGender(rs.getString("gender"));
        user.setBirthDate(rs.getDate("birthdate"));
        user.setStatus(rs.getInt("status"));
        user.setLoginType(rs.getString("login_type"));
        user.setSocialId(rs.getString("social_id"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            user.setNameChanged(rs.getBoolean("name_changed"));
        } catch (Exception e) {
            user.setNameChanged(false);
        }
        return user;
    };

    private final RowMapper<Address> addressMapper = (rs, ctx) -> {
        Address addr = new Address();
        addr.setId(rs.getInt("id"));
        addr.setUserId(rs.getInt("user_id"));
        addr.setReceiverName(rs.getString("receiver_name"));
        addr.setPhoneNumber(rs.getString("phone_number"));
        addr.setAddress(rs.getString("address"));
        addr.setCity(rs.getString("city"));
        addr.setDefault(rs.getBoolean("is_default"));
        return addr;
    };

    // Kiểm tra Email tồn tại
    public boolean checkExist(String email) {
        try {
            String query = "SELECT COUNT(*) FROM users WHERE email = ?";
            return DBContext.get().withHandle(handle -> handle.createQuery(query)
                    .bind(0, email)
                    .mapTo(Integer.class)
                    .one() > 0);
        } catch (Exception e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            return false;
        }
    }

    // Đăng ký người dùng mới
    public boolean signup(String fullname, String email, String password) {
        try {
            String query = "INSERT INTO users (fullname, email, password, role, status, login_type) " +
                    "VALUES (?, ?, ?, 0, 1, 'local')";
            DBContext.get().useHandle(handle -> handle.createUpdate(query)
                    .bind(0, fullname)
                    .bind(1, email)
                    .bind(2, password)
                    .execute());
            return true;
        } catch (Exception e) {
            System.err.println("Error during signup: " + e.getMessage());
            return false;
        }
    }

    // Đăng nhập
    public Optional<User> checkLogin(String email, String password) {
        try {
            String query = userSelectSql() + " WHERE email = ? AND password = ? AND status = 1";
            return DBContext.get().withHandle(handle -> handle.createQuery(query)
                    .bind(0, email)
                    .bind(1, password)
                    .map(userMapper)
                    .findFirst());
        } catch (Exception e) {
            System.err.println("Error during login: " + e.getMessage());
            return Optional.empty();
        }
    }

    // Cập nhật thông tin người dùng
    public boolean updateProfile(User user) {
        try {
            String query = "UPDATE users SET fullname = ?, phone = ?, gender = ?, birthdate = ?, avatar = ?, name_changed = ? WHERE id = ?";
            int rows = DBContext.get().withHandle(handle -> handle.createUpdate(query)
                    .bind(0, user.getFullName())
                    .bind(1, user.getPhone())
                    .bind(2, user.getGender())
                    .bind(3, user.getBirthDate())
                    .bind(4, user.getAvatar())
                    .bind(5, user.isNameChanged())
                    .bind(6, user.getId())
                    .execute());
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Error updating profile: " + e.getMessage());
            return false;
        }
    }

    // Cập nhật địa chỉ
    public boolean updateAddress(int userId, String address, String city, String receiverName, String phone) {
        try {
            DBContext.get().useHandle(handle -> {
                boolean hasAddress = handle.createQuery("SELECT COUNT(*) FROM user_addresses WHERE user_id = ? AND is_default = 1")
                        .bind(0, userId)
                        .mapTo(Integer.class)
                        .one() > 0;

                if (hasAddress) {
                    String sqlUpdate = "UPDATE user_addresses SET address = ?, city = ?, receiver_name = ?, phone_number = ? WHERE user_id = ? AND is_default = 1";
                    handle.createUpdate(sqlUpdate)
                            .bind(0, address).bind(1, city).bind(2, receiverName).bind(3, phone).bind(4, userId)
                            .execute();
                } else {
                    String sqlInsert = "INSERT INTO user_addresses (user_id, receiver_name, phone_number, address, city, is_default) VALUES (?, ?, ?, ?, ?, 1)";
                    handle.createUpdate(sqlInsert)
                            .bind(0, userId).bind(1, receiverName).bind(2, phone).bind(3, address).bind(4, city)
                            .execute();
                }
            });
            return true;
        } catch (Exception e) {
            System.err.println("Error updating address: " + e.getMessage());
            return false;
        }
    }

    // Lấy địa chỉ mặc định của người dùng
    public String getUserAddress(int userId) {
        try {
            String query = "SELECT address FROM user_addresses WHERE user_id = ? ORDER BY is_default DESC LIMIT 1";
            return DBContext.get().withHandle(handle -> handle.createQuery(query)
                    .bind(0, userId)
                    .mapTo(String.class)
                    .findFirst()
                    .orElse(""));
        } catch (Exception e) {
            System.err.println("Error getting user address: " + e.getMessage());
            return "";
        }
    }

    // Lấy địa chỉ của người dùng
    public List<Address> getAllAddressesByUserId(int userId) {
        try {
            String query = "SELECT * FROM user_addresses WHERE user_id = ?";
            return DBContext.get().withHandle(handle -> handle.createQuery(query)
                    .bind(0, userId)
                    .map(addressMapper)
                    .list());
        } catch (Exception e) {
            System.err.println("Error getting addresses: " + e.getMessage());
            return List.of();
        }
    }

    // Đổi mật khẩu của người dùng
    public boolean changePassword(int id, String newPassword) {
        try {
            String query = "UPDATE users SET password = ? WHERE id = ?";
            int rows = DBContext.get()
                    .withHandle(handle -> handle.createUpdate(query).bind(0, newPassword).bind(1, id).execute());
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Error changing password: " + e.getMessage());
            return false;
        }
    }

    // Cập nhật mật khẩu bằng email
    public boolean updatePasswordByEmail(String email, String newPassword) {
        try {
            String query = "UPDATE users SET password = ? WHERE email = ?";
            int rows = DBContext.get()
                    .withHandle(handle -> handle.createUpdate(query).bind(0, newPassword).bind(1, email).execute());
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Error updating password by email: " + e.getMessage());
            return false;
        }
    }

    // Lấy thông tin user theo email
    public Optional<User> getUserByEmail(String email) {
        try {
            String query = userSelectSql() + " WHERE email = ?";
            return DBContext.get().withHandle(handle -> handle.createQuery(query)
                    .bind(0, email)
                    .map(userMapper)
                    .findFirst());
        } catch (Exception e) {
            System.err.println("Error getting user by email: " + e.getMessage());
            return Optional.empty();
        }
    }

    // Thêm user mới (dùng cho social login)
    public boolean insertUser(User user) {
        try {
            String sql = "INSERT INTO users (fullname, email, password, avatar, login_type, social_id, role, status, created_at) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            DBContext.get().useHandle(handle -> handle.createUpdate(sql)
                    .bind(0, user.getFullName())
                    .bind(1, user.getEmail())
                    .bind(2, user.getPassword())
                    .bind(3, user.getAvatar())
                    .bind(4, user.getLoginType())
                    .bind(5, user.getSocialId())
                    .bind(6, user.getRole())
                    .bind(7, user.getStatus())
                    .bind(8, user.getCreatedAt())
                    .execute());
            return true;
        } catch (Exception e) {
            System.err.println("Error inserting user: " + e.getMessage());
            return false;
        }
    }

    // Cập nhật thông tin social login
    public boolean updateSocialInfo(User user) {
        try {
            String query = "UPDATE users SET login_type = ?, social_id = ?, avatar = ? WHERE id = ?";
            int rows = DBContext.get().withHandle(handle -> handle.createUpdate(query)
                    .bind(0, user.getLoginType())
                    .bind(1, user.getSocialId())
                    .bind(2, user.getAvatar())
                    .bind(3, user.getId())
                    .execute());
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Error updating social info: " + e.getMessage());
            return false;
        }
    }

    // Lấy danh sách tất cả người dùng
    public List<User> getAllUsers() {
        try {
            String sql = "SELECT * FROM users ORDER BY id DESC";
            return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                    .map(userMapper)
                    .list());
        } catch (Exception e) {
            System.err.println("Error getting all users: " + e.getMessage());
            return List.of();
        }
    }

    // Lấy thông tin user theo id
    public Optional<User> getUserById(int id) {
        try {
            String sql = userSelectSql() + " WHERE id = ?";
            return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                    .bind(0, id)
                    .map(userMapper)
                    .findFirst());
        } catch (Exception e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
            return Optional.empty();
        }
    }

    // Cập nhật trạng thái và vai trò của user
    public boolean updateUserStatusAndRole(int userId, int role, int status) {
        try {
            String sql = "UPDATE users SET role = ?, status = ? WHERE id = ?";
            int rows = DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                    .bind(0, role)
                    .bind(1, status)
                    .bind(2, userId)
                    .execute());
            return rows > 0;
        } catch (Exception e) {
            System.err.println("Error updating user status and role: " + e.getMessage());
            return false;
        }
    }

    // Đếm tổng số lượng người dùng
    public int countTotalUsers() {
        try {
            return DBContext.get().withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM users")
                    .mapTo(Integer.class)
                    .one());
        } catch (Exception e) {
            System.err.println("Error counting users: " + e.getMessage());
            return 0;
        }
    }

    private boolean hasRoleIdColumn() {
        return DBContext.get().withHandle(handle -> {
            try (ResultSet columns = handle.getConnection().getMetaData().getColumns(null, null, "users", "role_id")) {
                return columns.next();
            } catch (SQLException e) {
                return false;
            }
        });
    }

    private String userSelectSql() {
        if (hasRoleIdColumn()) {
            return "SELECT id, fullname, email, password, phone, role, role_id, avatar, gender, birthdate, status, login_type, social_id, created_at, name_changed FROM users";
        }
        return "SELECT id, fullname, email, password, phone, role, avatar, gender, birthdate, status, login_type, social_id, created_at, name_changed FROM users";
    }

}
