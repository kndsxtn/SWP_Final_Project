package validation;

import constant.Message;
import dal.UserDAO;
import dto.UserDto;

/**
 * 
 * @author Nguyen Dinh Giap
 */
public class UserValidator {

    private static final UserDAO userDAO = new UserDAO();

    // Regex patterns
    private static final String EMAIL_REGEX = "^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$";
    private static final String PHONE_REGEX = "^0[0-9]{9}$";
    private static final String USERNAME_REGEX = "^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9._-]+$";

    public static String validateLogin(String loginInput, String password) {
        if (loginInput == null || loginInput.trim().isEmpty()) {
            return Message.EMPTY_USERNAME;
        }
        if (password == null || password.trim().isEmpty()) {
            return Message.EMPTY_PASSWORD;
        }

        UserDto account = userDAO.getUserByUserName(loginInput);
        if (account == null) {
            account = userDAO.getUserByEmail(loginInput);
        }

        if (account == null) {
            return Message.NO_EXITING;
        }

        // Kiem tra trang thai tai khoan: chi cho phep account Active dang nhap
        if (!"Active".equalsIgnoreCase(account.getStatus())) {
            return "Tài khoản của bạn đã bị khóa hoặc ngừng hoạt động!";
        }

        String passwordDB = userDAO.getPasswordByUserName(account.getUsername());
        if (passwordDB == null || !passwordDB.trim().equals(password)) {
            return Message.ERROR_PASS;
        }

        return null;
    }

    public static String validateChangePassword(String oldPass, String currentPassDB, String newPass,
            String confirmPass) {
        if (oldPass == null || oldPass.trim().isEmpty()) {
            return "Mật khẩu cũ không được để trống!";
        }
        if (newPass == null || newPass.trim().isEmpty()) {
            return "Mật khẩu mới không được để trống!";
        }
        if (newPass.contains(" ")) {
            return "Mật khẩu mới không được chứa khoảng trắng!";
        }
        if (!oldPass.equals(currentPassDB)) {
            return Message.ERROR_PASS;
        }
        if (!newPass.equals(confirmPass)) {
            return Message.PASSWORD_MISMATCH;
        }
        return null;
    }

    public static String validateCreateUser(String username, String password, String fullName, String email,
            String phone) {
        if (username == null || username.trim().isEmpty())
            return Message.EMPTY_USERNAME;
        if (username.contains(" "))
            return "Tên đăng nhập không được chứa khoảng trắng!";
        if (!username.matches(USERNAME_REGEX))
            return "Tên đăng nhập phải bao gồm cả chữ và số, không khoảng trắng và có thể chứa (._-)!";
        
        if (password == null || password.trim().isEmpty())
            return Message.EMPTY_PASSWORD;
        if (password.contains(" "))
            return "Mật khẩu không được chứa khoảng trắng!";
        
        if (fullName == null || fullName.trim().isEmpty())
            return Message.EMPTY_FULLNAME;
        if (fullName.startsWith(" "))
            return "Họ và tên không được chứa khoảng trắng ở đầu!";
        if (fullName.contains("  "))
            return "Họ và tên không được chứa 2 khoảng trắng liên tiếp!";
            
        if (email == null || email.trim().isEmpty())
            return "Email không được để trống!";
        if (email.contains(" "))
            return "Email không được chứa khoảng trắng!";
        if (!email.matches(EMAIL_REGEX))
            return Message.INVALID_EMAIL;
            
        if (phone == null || phone.trim().isEmpty())
            return "Số điện thoại không được để trống!";
        if (phone.contains(" "))
            return "Số điện thoại không được chứa khoảng trắng!";
        if (!phone.matches(PHONE_REGEX))
            return "Số điện thoại phải có đúng 10 chữ số (bắt đầu bằng số 0)!";

        if (userDAO.getUserByUserName(username) != null)
            return Message.ACCOUNT_EXIST;
        if (userDAO.getUserByEmail(email) != null)
            return Message.EMAIL_EXIST;
        if (userDAO.getUserByPhone(phone) != null)
            return Message.PHONE_EXIST;

        return null;
    }

    public static String validateProfileUpdate(String fullName, String email, String phone, int userId) {
        if (fullName == null || fullName.trim().isEmpty())
            return Message.EMPTY_FULLNAME;
        if (fullName.startsWith(" "))
            return "Họ và tên không được chứa khoảng trắng ở đầu!";
        if (fullName.contains("  "))
            return "Họ và tên không được chứa 2 khoảng trắng liên tiếp!";
            
        if (email == null || email.trim().isEmpty())
            return "Email không được để trống!";
        if (email.contains(" "))
            return "Email không được chứa khoảng trắng!";
        if (!email.matches(EMAIL_REGEX))
            return Message.INVALID_EMAIL;
            
        if (phone == null || phone.trim().isEmpty())
            return "Số điện thoại không được để trống!";
        if (phone.contains(" "))
            return "Số điện thoại không được chứa khoảng trắng!";
        if (!phone.matches(PHONE_REGEX))
            return "Số điện thoại phải có đúng 10 chữ số (bắt đầu bằng số 0)!";

        UserDto emailUser = userDAO.getUserByEmail(email);
        if (emailUser != null && emailUser.getUserId() != userId)
            return Message.EMAIL_EXIST;

        UserDto phoneUser = userDAO.getUserByPhone(phone);
        if (phoneUser != null && phoneUser.getUserId() != userId)
            return Message.PHONE_EXIST;

        return null;
    }
}
