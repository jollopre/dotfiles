# Reveal every secret so that it can be properly placed within the machine
echo "Decrypt all hidden files"
git-secret reveal

echo "Copy flywire decrypted files into ~"
cp -R flywire ~
ln -s -f ~/flywire/.extended-routes ~
ln -s -f ~/flywire/.aws ~
ln -s -f ~/flywire/.tokens.sh ~

echo "Copy ssh decrypted files into ~"
cp -R .ssh ~
chmod 0600 ~/.ssh/id_rsa
