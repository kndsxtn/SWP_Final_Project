package validation;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailValidation {

    private final String fromEmail = "dinhgiap0409@gmail.com"; 
    private final String appPassword = "suka dmks npef xhgz";

    public void sendNewPasswordEmail(String toEmail, String username, String newPassword) {
        
        //cau hinh mail server (Gmail)
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        //tao session de gui mail
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            //noi dung email
            Message message = new MimeMessage(session);
            MimeMessage mimeMessage = (MimeMessage) message;
            mimeMessage.setFrom(new InternetAddress(fromEmail));
            mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            mimeMessage.setSubject("Yêu cầu cấp lại mật khẩu cho tài khoản: " + username, "UTF-8");
            
            String content = "Xin chào " + username + ",\n\n"
                    + "Bạn đã yêu cầu cấp lại mật khẩu. Hệ thống đã tự tạo mật khẩu mới cho bạn.\n\n"
                    + "Mật khẩu mới của bạn là: " + newPassword + "\n\n"
                    + "Vui lòng đăng nhập và đổi lại mật khẩu để đảm bảo bảo mật.\n\n"
                    + "Trân trọng,\nBan quản trị hệ thống.";
            
            mimeMessage.setText(content, "UTF-8");

            // thuc hien gui mail
            Transport.send(message);
            System.out.println("Email sent successfully to " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("Error sending email: " + e.getMessage());
        }
    }
}
