package dal;

import model.Address;
import org.jdbi.v3.core.mapper.RowMapper;

import java.util.List;
import java.util.Optional;
import java.util.Collections;

public class AddressDAO {
    private final RowMapper<Address> addressMapper = (rs, ctx) -> {
        Address addr = new Address();
        addr.setId(rs.getInt("id"));
        addr.setUserId(rs.getInt("user_id"));
        addr.setReceiverName(rs.getString("receiver_name"));
        addr.setPhoneNumber(rs.getString("phone_number"));
        addr.setAddress(rs.getString("address"));
        addr.setCity(rs.getString("city"));
        addr.setDefault(rs.getInt("is_default") == 1);
        addr.setProvinceId(rs.getInt("province_id"));
        addr.setDistrictId(rs.getInt("district_id"));
        addr.setWardCode(rs.getString("ward_code"));
        return addr;
    };

    public List<Address> getAddressesByUserId(int userId) {
        try {
            String query = "SELECT id, user_id, receiver_name, phone_number, address, city, is_default, province_id, district_id, ward_code " +
                    "FROM user_addresses WHERE user_id = ? ORDER BY is_default DESC, id DESC";

            return DBContext.get().withHandle(handle -> handle.createQuery(query)
                    .bind(0, userId)
                    .map(addressMapper)
                    .list());
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return Collections.emptyList();
        }
    }

    public Optional<Address> getAddressById(int addressId) {
        try {
            String query = "SELECT id, user_id, receiver_name, phone_number, address, city, is_default, province_id, district_id, ward_code " +
                    "FROM user_addresses WHERE id = ?";

            return DBContext.get().withHandle(handle -> handle.createQuery(query)
                    .bind(0, addressId)
                    .map(addressMapper)
                    .findFirst());
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return Optional.empty();
        }
    }

    public boolean addAddress(Address address) {
        try {
            DBContext.get().useHandle(handle -> {
                if (address.isDefault()) {
                    handle.createUpdate("UPDATE user_addresses SET is_default = 0 WHERE user_id = ?")
                            .bind(0, address.getUserId())
                            .execute();
                }

                String query = "INSERT INTO user_addresses (user_id, receiver_name, phone_number, address, city, is_default, province_id, district_id, ward_code) "
                        +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                handle.createUpdate(query)
                        .bind(0, address.getUserId())
                        .bind(1, address.getReceiverName())
                        .bind(2, address.getPhoneNumber())
                        .bind(3, address.getAddress())
                        .bind(4, address.getCity())
                        .bind(5, address.isDefault() ? 1 : 0)
                        .bind(6, address.getProvinceId())
                        .bind(7, address.getDistrictId())
                        .bind(8, address.getWardCode())
                        .execute();
            });
            return true;
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return false;
        }
    }

    public boolean updateAddress(Address address) {
        try {
            DBContext.get().useHandle(handle -> {
                if (address.isDefault()) {
                    handle.createUpdate("UPDATE user_addresses SET is_default = 0 WHERE user_id = ? AND id != ?")
                            .bind(0, address.getUserId())
                            .bind(1, address.getId())
                            .execute();
                }

                String query = "UPDATE user_addresses SET receiver_name = ?, phone_number = ?, address = ?, city = ?, is_default = ?, province_id = ?, district_id = ?, ward_code = ? "
                        +
                        "WHERE id = ?";
                handle.createUpdate(query)
                        .bind(0, address.getReceiverName())
                        .bind(1, address.getPhoneNumber())
                        .bind(2, address.getAddress())
                        .bind(3, address.getCity())
                        .bind(4, address.isDefault() ? 1 : 0)
                        .bind(5, address.getProvinceId())
                        .bind(6, address.getDistrictId())
                        .bind(7, address.getWardCode())
                        .bind(8, address.getId())
                        .execute();
            });
            return true;
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return false;
        }
    }

    public boolean deleteAddress(int addressId) {
        try {
            String query = "DELETE FROM user_addresses WHERE id = ?";

            int rows = DBContext.get().withHandle(handle -> handle.createUpdate(query)
                    .bind(0, addressId)
                    .execute());
            return rows > 0;
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return false;
        }
    }

    public boolean setDefaultAddress(int userId, int addressId) {
        try {
            DBContext.get().useHandle(handle -> {
                handle.createUpdate("UPDATE user_addresses SET is_default = 0 WHERE user_id = ?")
                        .bind(0, userId)
                        .execute();

                handle.createUpdate("UPDATE user_addresses SET is_default = 1 WHERE id = ?")
                        .bind(0, addressId)
                        .execute();
            });
            return true;
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return false;
        }
    }

    public Optional<Address> getDefaultAddress(int userId) {
        try {
            String query = "SELECT id, user_id, receiver_name, phone_number, address, city, is_default, province_id, district_id, ward_code " +
                    "FROM user_addresses WHERE user_id = ? AND is_default = 1 LIMIT 1";

            return DBContext.get().withHandle(handle -> handle.createQuery(query)
                    .bind(0, userId)
                    .map(addressMapper)
                    .findFirst());
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return Optional.empty();
        }
    }

    public int countAddresses(int userId) {
        try {
            String query = "SELECT COUNT(*) FROM user_addresses WHERE user_id = ?";

            return DBContext.get().withHandle(handle -> handle.createQuery(query)
                    .bind(0, userId)
                    .mapTo(Integer.class)
                    .one());
        } catch (Exception e) {
            System.err.println(e.getMessage());
            return 0;
        }
    }
}
