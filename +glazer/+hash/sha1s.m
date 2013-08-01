function [hash, jstr] = sha1s( str )
%SHA1S Return the SHA1 hash of argument 'str'
%   Uses Java's built-in MesageDigest tools to find the SHA1
%   hash of a string.
%   Args: - str: a Matlab string
%   Returns: - hash: a 20x2 char array, containing the hex-vaule of the
%   SHA1 hash

md = java.security.MessageDigest.getInstance('SHA1');
jstr = java.lang.String(str);
md.update(jstr.getBytes('UTF-8'));
hash = dec2hex(typecast(md.digest(), 'uint8'));
end

