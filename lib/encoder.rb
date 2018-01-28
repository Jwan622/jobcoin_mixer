require 'openssl'

class Encoder
  KEY = "WeCanTalkAboutBetterWaysToStoreThis"

  def self.encrypt(addresses)
    address_string = addresses.join('|')
    # Since AES is considered as secure, I will use it as our algorithm.
    # AES comes with different key bit lengths: 128, 192, 256. The higher the
    # key length is, the harder it is to brute force it. Let's then set it to
    # encrypt mode.
    cipher = OpenSSL::Cipher::Cipher.new('AES-256-CFB').encrypt
    # This line turns our KEY into a 256 bit hash which we can then use
    # as a key for our AES encryption. AES requires a 256 bit key.
    key = Digest::SHA1.hexdigest(KEY)
    # This line also sets our IV and key set. Now we can encrypt some data.
    cipher.key = key
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
    key = Digest::SHA1.hexdigest(KEY)
    # This line also sets our IV and key set. Now we can encrypt some data.
    cipher.key = key
    s = [address_string].pack("H*").unpack("C*").pack("c*")
    cipher.update(s) + cipher.final
  end
end
