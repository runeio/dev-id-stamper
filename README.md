
dev-id-stamper  Project

This set of scripts, takes a firmware image (gl-ar150 Mips only),  and replaces the internal embedded following set of files with new provided files.

The effect is that the same pre-built firmware image is now personalized on a per-device basis.

The files effected are:

AWS certificates:
End-Device-Certificate, Rune-ROOT-Ceritifcate-Authority-Certificate, Device-Private-Key

AWS ID data:
AWS_CONFIG_FILE

all these are written to /usr/certs directory in the destination RFS.

The destination RFS is a squashfs filesystem dump contained within the firmware image, prepended by the Kernel binary.

