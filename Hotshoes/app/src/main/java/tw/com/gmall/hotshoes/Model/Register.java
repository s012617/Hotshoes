package tw.com.gmall.hotshoes.Model;
public class Register {

    public String memberID;
    public String companyID;
    public String token;

    public Register(String memberID, String companyID, String token) {
        this.memberID = memberID;
        this.companyID = companyID;
        this.token = token;
    }
}

