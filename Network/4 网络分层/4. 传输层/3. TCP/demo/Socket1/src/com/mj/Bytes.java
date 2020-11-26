package com.mj;

public class Bytes {
    public static byte[] intToByteArray(int i) {
        byte[] bs = new byte[4];
        bs[0] = (byte) ((i >> 24) & 0xFF);
        bs[1] = (byte) ((i >> 16) & 0xFF);
        bs[2] = (byte) ((i >> 8) & 0xFF);
        bs[3] = (byte) (i & 0xFF);
        return bs;
    }

    public static int byteArrayToInt(byte[] bs) {
        int i = 0;
        for (int k = 0; k < bs.length; k++) {
            i += (bs[k] & 0xFF) << (8 * (3 - k));
        }
        return i;
    }
}
