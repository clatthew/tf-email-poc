# Terraform  - trigger emails with Lambda function logs
## Usage instructions
1. Create a file `email.txt` containing your email in the root directory of the repo.
2. Run `terraform apply -auto-approve`
3. Click the confirmation link in your email
4. You will now receive an email every two minutes.

The content of the email can be customised by editing `src/pulisher.py`.
