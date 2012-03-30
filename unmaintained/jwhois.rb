require 'formula'

class Jwhois < Formula
  url 'http://ftpmirror.gnu.org/jwhois/jwhois-4.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/jwhois/jwhois-4.0.tar.gz'
  homepage 'http://directory.fsf.org/project/jwhois/'
  md5 '977d0ba90ee058a7998c94d933fc9546'

  # No whois entry in /etc/services. Use nicname instead.
  def patches; DATA; end

  def install
    # link fails on libiconv if not added here
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "LIBS=-liconv"
    system "make install"
  end
end


__END__
diff --git a/src/dns.c b/src/dns.c
index a818237..b5fe9c8 100644
--- a/src/dns.c
+++ b/src/dns.c
@@ -113,7 +113,7 @@ int
 lookup_host_addrinfo(struct addrinfo **res, const char *host, int port)
 {
   struct addrinfo hints;
-  char ascport[10] = "whois";
+  char ascport[10] = "nicname";
   int error;
 
   memset(&hints, 0, sizeof(hints));

diff --git a/src/utils.c b/src/utils.c
index dcd17af..d73fdbf 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -288,7 +288,7 @@ make_connect(const char *host, int port)
 
       retlen = sizeof(retval);
       error = getsockopt(sockfd, SOL_SOCKET, SO_ERROR, &retval, &retlen);
-      if (error < 0 || retval)
+      if (error < 0 || !retval)
 	{
 	  break;
 	}
