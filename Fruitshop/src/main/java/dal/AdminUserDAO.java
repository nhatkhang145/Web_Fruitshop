package dal;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import model.User;

public class AdminUserDAO {

    public boolean checkExist(String email) {
        String query = "SELECT COUNT(*) FROM users WHERE email = ?";
        return DBContext.get().withHandle(handle -> handle.createQuery(query)
                .bind(0, email)
                .mapTo(Integer.class)
                .one() > 0);
    }

    public void signup(String fullname, String email, String password) {
        boolean hasRoleIdColumn = hasRoleIdColumn();
        String query = hasRoleIdColumn
                ? "INSERT INTO users (fullname, email, password, role, role_id, status, login_type) VALUES (?, ?, ?, 0, NULL, 1, 'local')"
                : "INSERT INTO users (fullname, email, password, role, status, login_type) VALUES (?, ?, ?, 0, 1, 'local')";

        DBContext.get().useHandle(handle -> handle.createUpdate(query)
                .bind(0, fullname)
                .bind(1, email)
                .bind(2, password)
                .execute());
    }

    public User checkLogin(String email, String password) {
        boolean hasRoleIdColumn = hasRoleIdColumn();
        String query = userSelectSql(hasRoleIdColumn) + " WHERE email = ? AND password = ? AND status = 1";

        return DBContext.get().withHandle(handle -> handle.createQuery(query)
                .bind(0, email)
                .bind(1, password)
                .map((rs, ctx) -> mapUser(rs, hasRoleIdColumn))
                .findFirst()
                .orElse(null));
    }

    public void updateProfile(User user) {
        String query = "UPDATE users SET fullname = ?, phone = ?, gender = ?, birthdate = ?, avatar = ? WHERE id = ?";

        DBContext.get().useHandle(handle -> handle.createUpdate(query)
                .bind(0, user.getFullName())
                .bind(1, user.getPhone())
                .bind(2, user.getGender())
                .bind(3, user.getBirthDate())
                .bind(4, user.getAvatar())
                .bind(5, user.getId())
                .execute());
    }

    public void updateAddress(int userId, String address, String city, String receiverName, String phone) {
        DBContext.get().useHandle(handle -> {
            int count = handle.createQuery("SELECT COUNT(*) FROM user_addresses WHERE user_id = ? AND is_default = 1")
                    .bind(0, userId)
                    .mapTo(Integer.class)
                    .one();

            if (count > 0) {
                String sqlUpdate = "UPDATE user_addresses SET address = ?, city = ?, receiver_name = ?, phone_number = ? WHERE user_id = ? AND is_default = 1";
                handle.createUpdate(sqlUpdate)
                        .bind(0, address)
                        .bind(1, city)
                        .bind(2, receiverName)
                        .bind(3, phone)
                        .bind(4, userId)
                        .execute();
            } else {
                String sqlInsert = "INSERT INTO user_addresses (user_id, receiver_name, phone_number, address, city, is_default) VALUES (?, ?, ?, ?, ?, 1)";
                handle.createUpdate(sqlInsert)
                        .bind(0, userId)
                        .bind(1, receiverName)
                        .bind(2, phone)
                        .bind(3, address)
                        .bind(4, city)
                        .execute();
            }
        });
    }

    public String getUserAddress(int userId) {
        return DBContext.get().withHandle(handle -> handle
                .createQuery("SELECT address FROM user_addresses WHERE user_id = ? ORDER BY is_default DESC LIMIT 1")
                .bind(0, userId)
                .mapTo(String.class)
                .findFirst()
                .orElse(""));
    }

    public void changePassword(int id, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE id = ?";
        DBContext.get().useHandle(handle -> handle.createUpdate(query)
                .bind(0, newPassword)
                .bind(1, id)
                .execute());
    }

    public void updatePasswordByEmail(String email, String newPassword) {
        String query = "UPDATE users SET password = ? WHERE email = ?";
        DBContext.get().useHandle(handle -> handle.createUpdate(query)
                .bind(0, newPassword)
                .bind(1, email)
                .execute());
    }

    public User getUserByEmail(String email) {
        boolean hasRoleIdColumn = hasRoleIdColumn();
        String query = userSelectSql(hasRoleIdColumn) + " WHERE email = ?";

        return DBContext.get().withHandle(handle -> handle.createQuery(query)
                .bind(0, email)
                .map((rs, ctx) -> mapUser(rs, hasRoleIdColumn))
                .findFirst()
                .orElse(null));
    }

    public void insertUser(User user) {
        boolean hasRoleIdColumn = hasRoleIdColumn();
        String sql = hasRoleIdColumn
                ? "INSERT INTO users (fullname, email, password, avatar, login_type, social_id, role, role_id, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
                : "INSERT INTO users (fullname, email, password, avatar, login_type, social_id, role, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        DBContext.get().useHandle(handle -> {
            var update = handle.createUpdate(sql)
                    .bind(0, user.getFullName())
                    .bind(1, user.getEmail())
                    .bind(2, user.getPassword())
                    .bind(3, user.getAvatar())
                    .bind(4, user.getLoginType())
                    .bind(5, user.getSocialId())
                    .bind(6, user.getRole());

            if (hasRoleIdColumn) {
                update.bind(7, user.getRoleId());
                update.bind(8, user.getStatus());
                update.bind(9, user.getCreatedAt());
            } else {
                update.bind(7, user.getStatus());
                update.bind(8, user.getCreatedAt());
            }

            update.execute();
        });
    }

    public void updateSocialInfo(User user) {
        String query = "UPDATE users SET login_type = ?, social_id = ?, avatar = ? WHERE id = ?";

        DBContext.get().useHandle(handle -> handle.createUpdate(query)
                .bind(0, user.getLoginType())
                .bind(1, user.getSocialId())
                .bind(2, user.getAvatar())
                .bind(3, user.getId())
                .execute());
    }

    public List<User> getAllUsers() {
        boolean hasRoleIdColumn = hasRoleIdColumn();
        String sql = userSelectSql(hasRoleIdColumn) + " ORDER BY id DESC";

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .map((rs, ctx) -> mapUser(rs, hasRoleIdColumn))
                .list());
    }

    public boolean updateUserStatusAndRole(int userId, int role, Integer roleId, int status) {
        boolean hasRoleIdColumn = hasRoleIdColumn();
        if (hasRoleIdColumn) {
            String sql = "UPDATE users SET role = :role, role_id = :roleId, status = :status WHERE id = :userId";
            int rows = DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                    .bind("role", role)
                    .bind("roleId", roleId)
                    .bind("status", status)
                    .bind("userId", userId)
                    .execute());
            return rows > 0;
        }

        String sql = "UPDATE users SET role = :role, status = :status WHERE id = :userId";
        int rows = DBContext.get().withHandle(handle -> handle.createUpdate(sql)
                .bind("role", role)
                .bind("status", status)
                .bind("userId", userId)
                .execute());
        return rows > 0;
    }

    public User getUserById(int id) {
        boolean hasRoleIdColumn = hasRoleIdColumn();
        String sql = userSelectSql(hasRoleIdColumn) + " WHERE id = :id";

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .map((rs, ctx) -> mapUser(rs, hasRoleIdColumn))
                .findFirst()
                .orElse(null));
    }

    public int countTotalUsers() {
        return DBContext.get().withHandle(handle -> handle.createQuery("SELECT COUNT(*) FROM users")
                .mapTo(Integer.class)
                .one());
    }

    public List<model.Address> getAllAddressesByUserId(int userId) {
        String sql = "SELECT id, user_id, receiver_name, phone_number, address, city, is_default FROM user_addresses WHERE user_id = ?";

        return DBContext.get().withHandle(handle -> handle.createQuery(sql)
                .bind(0, userId)
                .map((rs, ctx) -> {
                    model.Address addr = new model.Address();
                    addr.setId(rs.getInt("id"));
                    addr.setUserId(rs.getInt("user_id"));
                    addr.setReceiverName(rs.getString("receiver_name"));
                    addr.setPhoneNumber(rs.getString("phone_number"));
                    addr.setAddress(rs.getString("address"));
                    addr.setCity(rs.getString("city"));
                    addr.setDefault(rs.getBoolean("is_default"));
                    return addr;
                })
                .list());
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

    private String userSelectSql(boolean includeRoleId) {
        if (includeRoleId) {
            return "SELECT id, fullname, email, password, phone, role, role_id, avatar, gender, birthdate, status, login_type, social_id, created_at FROM users";
        }
        return "SELECT id, fullname, email, password, phone, role, avatar, gender, birthdate, status, login_type, social_id, created_at FROM users";
    }

    private User mapUser(ResultSet rs, boolean includeRoleId) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("fullname"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getInt("role"));
        if (includeRoleId) {
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
        return user;
    }
}