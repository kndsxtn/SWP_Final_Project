package model;

import com.google.gson.annotations.SerializedName;
/**
 *
 * @author Nguyen Dinh Giap
 */
public class GoogleAccount {

    @SerializedName("sub")
    private String id;

    private String email;
    private String name;

    @SerializedName("given_name")
    private String givenName;

    @SerializedName("family_name")
    private String familyName;

    private String picture;

    @SerializedName("email_verified")
    private boolean emailVerified;

    public GoogleAccount() {
    }

    public String getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }

    public String getGivenName() {
        return givenName;
    }

    public String getFamilyName() {
        return familyName;
    }

    public String getPicture() {
        return picture;
    }

    public boolean isEmailVerified() {
        return emailVerified;
    }

    @Override
    public String toString() {
        return "GoogleAccount{" +
                "id='" + id + '\'' +
                ", email='" + email + '\'' +
                ", name='" + name + '\'' +
                ", givenName='" + givenName + '\'' +
                ", familyName='" + familyName + '\'' +
                ", picture='" + picture + '\'' +
                ", emailVerified=" + emailVerified +
                '}';
    }
}