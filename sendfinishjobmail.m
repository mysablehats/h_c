
mail = 'frederico.klein@plymouth.ac.uk';    % Replace with your email address


server = 'smtps.plymouth.ac.uk';     % Replace with your SMTP server

% Apply prefs and props

props = java.lang.System.getProperties;

props.setProperty('mail.smtp.port', '587');

props.setProperty('mail.smtp.auth','true');

props.setProperty('mail.smtp.starttls.enable','true');

setpref('Internet','E_mail', mail);

setpref('Internet','SMTP_Server', server);

setpref('Internet','SMTP_Username', mail);

setpref('Internet','SMTP_Password', password);

% Send the email

sendmail('mysablehats@gmail.com', assunto, msgmsg);
%sendmail('frederico.klein@gmail.com', assunto, msgmsg);
