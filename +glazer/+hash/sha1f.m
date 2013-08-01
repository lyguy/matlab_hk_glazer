function hash = sha1f( filename )
%SHA1F Return the SHA1 hash of the file located at 'filename'
%   Uses Java's built-in MesageDigest tools to find the SHA1
%   hash of a ;filename.
%   Args: - filename: name of file to be hashed
%   Returns: - hash: a 20x2 char array, containing the hex-vaule of the
%   SHA1 hash
md = java.security.MessageDigest.getInstance('SHA1');
fs = java.io.FileInputStream(java.io.File(filename));
digestream = java.security.DigestInputStream(fs,md);

while(digestream.read() ~= -1) end

hash = dec2hex(typecast(md.digest(), 'uint8'));
end

