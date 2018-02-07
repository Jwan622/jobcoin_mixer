require 'openssl'

class Mixer
  KEY = "WeCanTalkAboutBetterWaysToStoreThis"

  # used to identify which addresses in the jobcoin transaction history are
  # actually ours vs global transactions that have nothing to do with us.

  def self.encrypt(addresses, identifier)
    # unsure what characters are valid inputs for addresses, but this pipe seems
    # unlikely so therefore a good choice for a delimiter. Prob need to clean it first
    address_string = addresses.map{ |addr| addr.strip }.push(identifier).join('|')

    # Since AES is considered as secure, I will use it as our algorithm.
    # AES comes with different key bit lengths: 128, 192, 256. The higher the
    # key length is, the harder it is to brute force it. Let's then set the cipher object
    # to encrypt mode.
    cipher = OpenSSL::Cipher::Cipher.new('AES-256-CFB').encrypt

    # The initialization vector should be a random number.
    # After generation it can be transmitted openly and does not need to be kept
    # privately. The algorithm needs an initialization vector (IV) and the key
    # for its encryption and decryption process.
    # iv = cipher.random_iv

    # This line turns our KEY into a 256 bit hash which we can then use
    # as a key for our AES encryption. AES requires a 256 bit key which will be
    # 256/8 = 32 characters long
    cipher.key = Digest::SHA256.digest(KEY)

    # cipher.update takes a message and encrypts it using the IV and key given
    # before. cipher.final adds the final part of the cipher text to the end of
    # the encrypted message. This is needed if encrypted data is transmitted so
    # the decrypter knows when the end of the message is reached.
    encrypted_message = cipher.update(address_string) + cipher.final
    encrypted_message.unpack('H*')[0]
  end

  def self.decrypt(address_string)
    # set cipher to decrypt mode.
    cipher = OpenSSL::Cipher::Cipher.new('AES-256-CFB').decrypt

    # This line turns our KEY into a 256 bit hash which we can then use as a
    # key for our AES decryption.
    cipher.key = Digest::SHA256.digest(KEY)

    s = [address_string].pack("H*").unpack("C*").pack("c*")
    (cipher.update(s) + cipher.final).split('|')
  end
end
