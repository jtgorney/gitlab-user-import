Gitlab User Import Script - Formatting and How to Run
=====================================================
CSV file format:
First name, last name, email address. Gitlab assumes the username will be the email address and the first part of the email address.

Example:
John,Doe,jdoe@domain.tld
Jane,Doe,jdoe2@domain.tld
Kevin,Smith,ksmith@domain.tld

Call from command line:

ruby import.rb <Gitlab Admin Username> <Gitlab Admin Password> <Gitlab Site URL> <CSV File>

Example:

?> ruby import.rb admin mypassword https://gitlab.domain.tld import.csv

All users are assigned the password gitlabuser.
