secret_key_path_import=${args[--import-secret-key]}
public_key_path_import=${args[--import-public-key]}
secret_key_id=${args[--export-secret-key]}
public_key_id=${args[--export-public-key]}
delete_key_id=${args[--delete-key]}
list_secret_keys=${args[--list-secret-keys]}
list_public_keys=${args[--list-public-keys]}

if [[ $secret_key_path_import ]]; then
  echo "Decrypting private key from $secret_key_path_import"
  gpg -o private.key -d $secret_key_path_import
  echo "Importing private key..."
  gpg --allow-secret-key-import --import private.key
  echo "Deleting generated private.key file"
  rm private.key
fi

if [[ $public_key_path_import ]]; then
  echo "Decrypting public key from $public_key_path_import"
  gpg -o public.key -d $public_key_path_import
  echo "Importing public key..."
  gpg --import public.key
  echo "Deleting generated public.key file"
  rm public.key
fi

if [[ $secret_key_id ]]; then
  echo "Exporting private key..."
  gpg --export-secret-keys $secret_key_id > private.key
  echo "Encrypting private key id '$secret_key_id'"
  gpg --symmetric --cipher-algo AES256 private.key
  echo "Deleting generated private.key file"
  rm private.key
  echo "Encrypted private key file located at './private.key.gpg'. Please copy it on safer place"
fi

if [[ $public_key_id ]]; then
  echo "Exporting public key..."
  gpg --export $public_key_id > public.key
  echo "Encrypting public key id '$public_key_id'"
  gpg --symmetric --cipher-algo AES256 public.key
  echo "Deleting generated public.key file"
  rm public.key
  echo "Encrypted public key file located at './public.key.gpg'. Please copy it on safer place"
fi

if [[ $delete_key_id ]]; then
  echo "Deleting secret-key with id '$delete_key_id'"
  gpg --delete-secret-keys $delete_key_id
  echo "Deleting public-key with id '$delete_key_id'"
  gpg --delete-keys $delete_key_id
fi

if [[ $list_secret_keys ]]; then
  gpg --list-secret-keys
fi

if [[ $list_public_keys ]]; then
  gpg --list-keys
fi

if [[ -z $secret_key_path_import && -z $public_key_path_import && -z $secret_key_id && -z $public_key_id && -z $delete_key_id && -z $list_secret_keys && -z $list_public_keys ]]; then
  echo "Listing public keys since no flags were passed"
  gpg --list-keys
fi
