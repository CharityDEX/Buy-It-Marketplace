package it.eat.back.core.service;

import it.eat.back.core.dbinterface.IDBJournal;
import org.apache.commons.text.StringSubstitutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Service;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;


/**
 * Mail sender service
 */
@ConfigurationProperties("mail")
@Service
public class MailService {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private final IDBJournal journal;

    @Value("${mail.smtp.host:}")
    private String mailHost;

    @Value("${mail.smtp.port:25}")
    private String mailPort;

    @Value("${mail.smtp.from:}")
    private String mailFrom;

    @Value("${mail.smtp.templatepath}")
    private String templatePath;


//    @Value("${mail.templates.newRegistration}")
//    private String newRegistration;
//    @Value("${mail.templates}")
    private final Map<String, String> templates = new HashMap<>();

    private final Map<String, String> subjects = new HashMap<>();
    public Map<String, String> getSubjects() {
        return this.subjects;
    }

    public Map<String, String> getTemplates() {
        return this.templates;
    }

    /**
     * class constructor
     * @param journal journal interface implementation
     */
    public MailService(final IDBJournal journal) {
        this.journal = journal;
    }

    /**
     * send email
     * @param template template email
     * @param to send to emai
     * @param userName userName
     * @return status send
     */
    public boolean send(final String template, final String to, final String userName) {
        return send(template, to, userName, "0000");
    }
    /**
     * send email
     * @param template template email
     * @param to send to email
     * @param userName userName
     * @param verificationCode code to send
     * @return status send
     */
    public boolean send(final String template, final String to, final String userName, final String verificationCode) {
        try {
            Properties properties = System.getProperties();

            String fileName = templatePath + "/" + getTemplates().get(template);
            String subjectTemplate = getSubjects().get(template);

            Map<String, String> values = new HashMap<>();
            values.put("verificationCode", verificationCode);
            values.put("userName", userName);

            StringSubstitutor sub = new StringSubstitutor(values, "${", "}");

            BufferedReader reader = new BufferedReader(new FileReader(fileName));
            StringBuilder stringBuilder = new StringBuilder();
            String line;
            String ls = System.getProperty("line.separator");
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
                stringBuilder.append(ls);
            }
//            stringBuilder.deleteCharAt(stringBuilder.length() - 1);
            reader.close();

            String contentTemplate = stringBuilder.toString();

            String contentResult = sub.replace(contentTemplate);
            String subject = sub.replace(subjectTemplate);
            properties.put("mail.smtp.host", mailHost);
            properties.put("mail.smtp.port", mailPort);
            Session session = Session.getDefaultInstance(properties);
            try {
                MimeMessage message = new MimeMessage(session); // email message

                message.setFrom(new InternetAddress(mailFrom)); // setting header fields

                message.addRecipient(Message.RecipientType.TO, new InternetAddress(to, userName));

                message.setSubject(subject); // subject line

                // actual mail body
                message.setContent(contentResult, "text/html");
                // Send message
                Transport.send(message);
                journal.addToJournalMail(template, userName, to, verificationCode);
                return true;

            } catch (MessagingException mex) {
//                mex.printStackTrace();
                logger.error(mex.toString());
                return false;
            }
        } catch (Exception e) {
            logger.error(e.toString());
//            e.printStackTrace();
            return false;
        }
    }

}
