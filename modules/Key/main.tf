resource "aws_key_pair" "my_key_pair" {
  key_name = "sanity-key"
  public_key = file("~/.ssh/id_ed25519.pub") 
}